//
//  NotificationViewController.swift
//  Content
//
//  Created by hyunndy on 2020/08/25.
//  Copyright © 2020 hyunndy. All rights reserved.
//

/*
 
 디바이스토큰: 5226E355B17AB092807297C8A9C66858EA17F4ED1D0DCD859C1AF634699E469B
 테스트 jSon
 {
    "aps":{
       "alert":"Notification 테스트입니다",
       "badge":1,
       "sound":"default",
       "category":"CustomSamplePush",
       "mutable-content":"1"
    },
    "urlImageString":"https://res.cloudinary.com/demo/image/upload/sample.jpg"
 }
 */



import UIKit
import UserNotifications
import UserNotificationsUI

class NotificationViewController: UIViewController, UNNotificationContentExtension {

    @IBOutlet weak var ivNotification: UIImageView!
    @IBOutlet weak var lbNotification: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func didReceive(_ notification: UNNotification) {
        let content = notification.request.content

        var urlString:String? = nil
        
        /*
        if let urlImageFromFCM = content.userInfo["gcm.notification.imageUrl"] as? String {
            urlString = urlImageFromFCM
        }
        
        if let urlImageFromAPNs = content.userInfo["urlImageString"] as? String {
            urlString = urlImageFromAPNs
        }
 */
        
        if let urlImageString = content.userInfo["urlImageString"] as? String {
            if let url = URL(string: urlImageString) {
                URLSession.downloadImage(atURL: url) { [weak self] (data, error) in
                    if let _ = error {
                        return
                    }
                    guard let data = data else { return }
                    
                    DispatchQueue.main.async {
                        self?.ivNotification.image = UIImage(data: data)
                    }
                }
            }
        }
        
        lbNotification.text = content.body
    }

}

extension URLSession {
    
    class func downloadImage(atURL url: URL, withCompletionHandler completionHandler: @escaping (Data?, NSError?) -> Void) {
        let dataTask = URLSession.shared.dataTask(with: url) { (data, urlResponse, error) in
            completionHandler(data, nil)
        }
        dataTask.resume()
    }
}
