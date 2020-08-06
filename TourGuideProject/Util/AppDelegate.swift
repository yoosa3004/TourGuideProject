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
import Firebase
import Then

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // 파이어베이스
        FirebaseApp.configure()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        // 루트 뷰 컨트롤러가 될 뷰 컨트롤러를 생성한다.
        let tabBarVC = ESTabBarController()
        
        let vcTourSpot = TourSpotListViewController()
        let vcFestival = FestivaListTableViewController()
        let vcAccount = AccountViewController()
        
        vcTourSpot.tabBarItem.title = "관광지"
        vcFestival.tabBarItem.title = "행사"
        vcAccount.tabBarItem.title = "나의 계정"
        
        tabBarVC.viewControllers = [vcTourSpot,vcFestival,vcAccount]
        tabBarVC.tabBar.tintColor = UIColor.red
        
        vcTourSpot.tabBarItem.image = UIImage(named: "tour_guide.png")?.withRenderingMode(.alwaysOriginal)
        vcFestival.tabBarItem.image = UIImage(named: "festival.png")?.withRenderingMode(.alwaysOriginal)
        vcAccount.tabBarItem.image = UIImage(named: "user.png")?.withRenderingMode(.alwaysOriginal)
        
        // 위에서 생성한 뷰 컨트롤러로 내비게이션 컨트롤러를 생성한다.
        let vcMainNavigation = UINavigationController(rootViewController: tabBarVC)
        
        // 드로어 컨트롤러를 넣을 네비게이션 컨트롤러
        let vcDrawerNavigation = UINavigationController(rootViewController: DrawerViewController())
        
        let vcDrawer = KYDrawerController(drawerDirection: .left, drawerWidth: window?.frame.width ?? 0)
        vcDrawer.mainViewController = vcMainNavigation
        
        // 윈도우의 루트 뷰 컨트롤러로 내비게이션 컨트롤러를 설정한다.
        window?.rootViewController = vcDrawer
        window?.makeKeyAndVisible()
        
        vcDrawer.drawerViewController = vcDrawerNavigation
        
        // Override point for customization after application launch.
        return true
    }
}
