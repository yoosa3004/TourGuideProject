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
        
        sleep(2)
        
        // 파이어베이스
        FirebaseApp.configure()
        
        // 메세지/NotificationCenter 델리게이트 설정
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        
        // 인증 요청
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { _, _ in }
        
        // APNs 요청
        application.registerForRemoteNotifications()
        
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
    
    // registerForRemoteNotifications()를 호출하면 불리는 함수
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print("[Log] deviceToken :", deviceTokenString)
        
        // 디바이스 토큰을 APNsToken 으로 설정한다.
        Messaging.messaging().apnsToken = deviceToken
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    // 앱이 포그라운드에 있을 때 호출되는 함수
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
    
    // Notification에 대한 사용자의 응답 처리를 할 수 있는 함수
    // response의 actionIdentifier을 통해 사용자가 Notificatio을 종료한 경우, 열었을(클릭했을) 경우의 처리를 할 수 있다.
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
}

extension AppDelegate: MessagingDelegate {
    
    // 토큰이 새로 생성되었을 때 호출되는 함수.
    // 토큰이 새로 갱신되는 경우는 3가지 경우이다. [ 1. 사용자가 새 기기에서 앱을 복원한 경우, 2. 사용자가 앱 삭제/재설치한 경우 3. 사용자가 앱 데이터 소거한 경우 ]
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        let dataDict: [String: String] = ["token": fcmToken]
        
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
    }
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("[Log] didReceive :", messaging)
    }
}
