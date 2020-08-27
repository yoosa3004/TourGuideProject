//
//  AppDelegate.swift
//  TourGuideProject
//
//  Created by hyunndy on 2020/07/07.
//  Copyright © 2020 hyunndy. All rights reserved.
//

import UIKit
import ESTabBarController_swift
import KYDrawerController
import FirebaseCore
import FirebaseMessaging
import Then

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        sleep(3)
        
        // 파이어베이스
        FirebaseApp.configure()
        
        // Notification 관련 설정
        configureNotification()
        
        // 탭바 VC 세팅
        let vcTourSpot = TourSpotListViewController().then {
            $0.tabBarItem.title = "관광지"
            $0.tabBarItem.image = UIImage(named: "tour_guide.png")?.withRenderingMode(.alwaysOriginal)
        }
        
        let vcFestival = FestivaListTableViewController().then {
            $0.tabBarItem.title = "행사"
            $0.tabBarItem.image = UIImage(named: "festival.png")?.withRenderingMode(.alwaysOriginal)
        }
        
        let vcAccount = AccountViewController().then {
            $0.tabBarItem.title = "나의 계정"
            $0.tabBarItem.image = UIImage(named: "user.png")?.withRenderingMode(.alwaysOriginal)
        }

        let vcTabBar = ESTabBarController().then {
            $0.viewControllers = [vcTourSpot, vcFestival, vcAccount]
            $0.tabBar.tintColor = UIColor.red
        }
        
        // 메인으로 쓰일 네비게이션 컨트롤러
        let vcMainNavigation = UINavigationController(rootViewController: vcTabBar)
        
        // 드로어메뉴에 쓰일 네비게이션 컨트롤러
        let vcDrawerNavigation = UINavigationController(rootViewController: DrawerViewController())
        
        // KYDrawerController 라이브러리 사용 -> 메인/드로어 컨트롤러 세팅
        let vcDrawer = KYDrawerController(drawerDirection: .left, drawerWidth: UIScreen.main.bounds.width)
        vcDrawer.mainViewController = vcMainNavigation
        
        // 윈도우 세팅
        window = UIWindow().then {
            $0.frame = UIScreen.main.bounds
            $0.rootViewController = vcDrawer
            $0.makeKeyAndVisible()
        }

        vcDrawer.drawerViewController = vcDrawerNavigation
        
        return true
    }
    
    func configureNotification() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { _, _ in }
        
        // 메세지/NotificationCenter 델리게이트 설정
        Messaging.messaging().delegate = self
        center.delegate = self
        
        // use UNNotificationCategory to defines a type of notification that your excutable can receive as this is possible to customized a specific push notification
        let openAction = UNNotificationAction(identifier: "OpenNotification", title: NSLocalizedString("TourGuide", comment: "TourGuide앱의 알림입니다."), options: UNNotificationActionOptions.foreground)
        let defaultCategory = UNNotificationCategory(identifier: "CustomSamplePush", actions: [openAction], intentIdentifiers: [], options: [])
        center.setNotificationCategories(Set([defaultCategory]))

        UIApplication.shared.registerForRemoteNotifications()
    }
    
    /*
     APNs -> Device Notification 보낼 때 APNs 토큰이 필요. APNs 토큰 = 각 기기의 주소 (= Device Token)
     Client: APNs Token + (APNs Token을 보냈을 때 FCM에서 알려주는) FCM Token 을 저장 후 Server에 전송
     Server: 이벤트가 발생할 때 마다 각 Token을 이용해 APNs, FCM에 Push 발송!
     
     근데 왜 APNs, FCM Token 2개가 필요할까?
     -> 구글, 애플이 다른회사기 때문에 FCM Token은 매번 반드시 올거라는 보장이 없기 때문에 대비용으로 둘 다 갖는다.
     */
    // registerForRemoteNotifications()를 호출하면 불리는 함수
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        tgLog("######## [Log] deviceToken : \(deviceTokenString)")
        
        // 디바이스 토큰을 APNsToken 으로 설정한다.
        Messaging.messaging().setAPNSToken(deviceToken, type: .sandbox) // apns토큰 = 각 기기의 푸쉬를 쏘기위한 주소
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        tgLog("#### enter the background")
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        tgLog("#### enter the foreground")
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    // 앱이 포그라운드에 있을 때 호출되는 함수
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert,.sound])
    }
    
    // Notification에 대한 사용자의 응답 처리를 할 수 있는 함수
    // response의 actionIdentifier을 통해 사용자가 Notificatio을 종료한 경우, 열었을(클릭했을) 경우의 처리를 할 수 있다.
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        switch response.actionIdentifier {
        case UNNotificationDismissActionIdentifier:
            tgLog("###### Dismiss Action")
        case UNNotificationDefaultActionIdentifier:
            tgLog("###### Open Action")
        default:
            tgLog("default")
        }
        
        completionHandler()
    }
}

extension AppDelegate: MessagingDelegate {
    
    // 토큰이 새로 생성되었을 때 호출되는 함수.
    // 토큰이 새로 갱신되는 경우는 3가지 경우이다. [ 1. 사용자가 새 기기에서 앱을 복원한 경우, 2. 사용자가 앱 삭제/재설치한 경우 3. 사용자가 앱 데이터 소거한 경우 ]
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        let dataDict: [String: String] = ["token": fcmToken]
        tgLog("######## [Log] FCMToken : \(fcmToken)")
        
        // 서버에 보낼 FCMToken
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        
        Messaging.messaging().unsubscribe(fromTopic: "HyunndyTest")
    }
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("[Log] didReceive :", messaging)
    }
}
