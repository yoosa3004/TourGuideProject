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
import Then

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // 파이어베이스
        FirebaseApp.configure()
        
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
}
