//
//  NotificationDelegate.swift
//  TourGuideProject
//
//  Created by hyunndy on 2020/08/25.
//  Copyright © 2020 hyunndy. All rights reserved.
//

/*
 Handling Notification interactions and show notification with open app
 
 Custom Push Notification ( Using Notification Service Extension and Notification Content Extension )
 */

import Foundation
import UserNotifications
import UserNotificationsUI

class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    
    // 앱이 포그라운드에 있을 때 호출되는 함수
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
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
