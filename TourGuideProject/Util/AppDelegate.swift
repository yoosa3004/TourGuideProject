//
//  AppDelegate.swift
//  TourGuideProject
//
//  Created by hyunndy on 2020/07/07.
//  Copyright © 2020 hyunndy. All rights reserved.
//

import UIKit
import ESTabBarController_swift
import Firebase
import Then

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        if #available(iOS 13, *) {
            
            // iOS 13 이상인 경우 AppDelegate와 SceneDelegate가 모두 호출되기 때문에 여기서 새로 생성하면 중복이 발생하므로 SceneDelegate만 처리되도록 분기해야함
            
        }else {
            
            window = UIWindow(frame: UIScreen.main.bounds)
            
            // ESTabBarController 넣기
            //----------------------------------------------------------
            // 루트 뷰 컨트롤러가 될 뷰 컨트롤러를 생성한다.
            let tabBarVC = ESTabBarController()
            
            let v1 = TourSpotListViewController()
            let v2 = FestivalListViewController()
            let v3 = AccountViewController()
            
            v1.tabBarItem.title = "관광지"
            v2.tabBarItem.title = "행사"
            v3.tabBarItem.title = "나의 계정"
            
            tabBarVC.viewControllers = [v1,v2,v3]
            
            tabBarVC.tabBar.tintColor = UIColor.red
            //----------------------------------------------------------
            
            // 위에서 생성한 뷰 컨트롤러로 내비게이션 컨트롤러를 생성한다.
            let navigationVC = UINavigationController(rootViewController: tabBarVC)
            
            // 윈도우의 루트 뷰 컨트롤러로 내비게이션 컨트롤러를 설정한다.
            window?.rootViewController = navigationVC
            window?.makeKeyAndVisible()
            //----------------------------------------------------------
            
            // 파이어베이스
            FirebaseApp.configure()
            
            
        }
        
        // Override point for customization after application launch.
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    // MARK: sceneSessions는 앱에서 생성한 모든 scene의 정보를 관리한다.
    
    // scene을 만들 때 구성 객체를 반환해야 한다.
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    // 사용자가 app switcher를 통해 scene을 닫을 때 호출된다.
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
}

