//
//  NotificationHelper.swift
//  TourGuideProject
//
//  Created by hyunndy on 2020/08/26.
//  Copyright © 2020 hyunndy. All rights reserved.
//

/*
 Local Notification을 위한 Helper Class.
 (APNs 아님)
 
 로그인 시
 - DB에 있는 행사 정보들을 긁어와서 Notification에 등록
 
 로그아웃 시
 - Notification에 Pending 되어있는 액션 모두 취소
 
 찜리스트에 넣을 때
 - Notification 등록
 
 찜리스트에서 뺄 때
 - Notification에서 해제
 
 참고페이지
 https://www.appsdeveloperblog.com/how-to-read-and-cancel-local-notification-requests/

 */

import Foundation
import FirebaseFirestore
import FirebaseAuth
import UserNotifications

class NotificationHelper {
    
    let db = Firestore.firestore()
    
    // 로그인 시
    func addAllUserNotification(userid: String) {
        
        // DB의 Festival 정보들을 긁어와서 contentID 조회 후 Notification 추가한다.
        let docRef = db.collection("zzimList").document(userid).collection("Festival")
        docRef.getDocuments { (querySnapshot, err) in
            if let query = querySnapshot {
                
                // DB에서 content
                for document in query.documents {
                    if let festivalInfo = ZZimListInfo(JSON: document.data()) {
                        
                        // 행사 정보 찾았으면 Notification에 추가한다!
                        if let contentId = festivalInfo.contentId, let eventDate = festivalInfo.eventstartdate {
                            self.addNotification(contentId: contentId, title: festivalInfo.title ?? "", eventDate: eventDate)
                        }
                    }
                }
            }
        }
    }
    
    // 로그아웃 시
    func removeAllUserNotification() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
    
    // 찜리스트에 넣을 때 - contentId로 식별자하는게 좋을듯?
    func addNotification(contentId:Int, title: String, eventDate: Int) {
        
        // 현재날짜보다 행사 시작 날짜가 빠르면 Notification 띄워주지 않는다.
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        if let currentDate = Int(formatter.string(from: Date())) {
            if eventDate < currentDate {
                return
            }
        }
        
        // notification 등록
        if let date = eventDate.getDateFromInt() {
            
            let content = UNMutableNotificationContent().then {
                $0.title = "행사 임박 알림"
                $0.body =  "찜해놓은 행사 \(title)가 곧 시작됩니다."
            }
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
            let request = UNNotificationRequest(identifier: "Festival\(contentId)isComing", content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        }
    }
    
    // 찜리스트에서 밸 때
    func removeNotification(contentId: Int) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["Festival\(contentId)isComing"])
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: ["Festival\(contentId)isComing"])
    }
}

extension Int {
    func getDateFromInt() -> DateComponents? {
        
        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "yyyyMMdd"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?

        if let date = dateFormatter.date(from: String(self)) {
            
            var dateCompenents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
            dateCompenents.setValue(8, for: .hour)
            dateCompenents.setValue(0, for: .minute)
            
            return dateCompenents
        } else {
            return nil
        }
    }
}
