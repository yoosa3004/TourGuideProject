//
//  NotificationService.swift
//  Service
//
//  Created by hyunndy on 2020/08/25.
//  Copyright © 2020 hyunndy. All rights reserved.
//


/*
 
 In the service extension you can change the notification, the title, content and put an image in the right side
 
 In the Content extension you can chanhe details of the notification ( storyboard for custom layout, whatever you want.)
 
 Notification에 이미지 추가를 위해....
 1. push를 통해 image 전송, 2. notification rendering 전에 download.
 2. image URL은 HTTPS여야 한다.
 
 */


import UserNotifications

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        if let bestAttemptContent = bestAttemptContent {
            
            // Modify the notification content here...
            bestAttemptContent.title = "\(bestAttemptContent.title) [알림]"
            print(request.content.userInfo)
            print(request.content)
            
            if let urlImage = request.content.userInfo["gcm.notification.imageUrl"] {
                print("######## \(urlImage)")
            }
            
            var urlString:String? = nil
            
            if let urlImageFromFCM = request.content.userInfo["gcm.notification.imageUrl"] as? String {
                urlString = urlImageFromFCM
            }
            
            if let urlImageFromAPNs = request.content.userInfo["urlImageString"] as? String {
                urlString = urlImageFromAPNs
            }
            
            if urlString != nil, let fileUrl = URL(string: urlString!) {
                print("fileUrl: \(fileUrl)")
                
                guard let imageData = NSData(contentsOf: fileUrl) else {
                    contentHandler(bestAttemptContent)
                    return
                }
                guard let attachment = UNNotificationAttachment.saveImageToDisk(fileIdentifier: "image.jpg", data: imageData, options: nil) else {
                    print("error in UNNotificationAttachment.saveImageToDisk()")
                    contentHandler(bestAttemptContent)
                    return
                }
                
                bestAttemptContent.attachments = [ attachment ]
            }
            
            contentHandler(bestAttemptContent)
        }
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }

}

@available(iOSApplicationExtension 10.0, *)
extension UNNotificationAttachment {
    
    static func saveImageToDisk(fileIdentifier: String, data: NSData, options: [NSObject : AnyObject]?) -> UNNotificationAttachment? {
        let fileManager = FileManager.default
        let folderName = ProcessInfo.processInfo.globallyUniqueString
        let folderURL = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(folderName, isDirectory: true)
        
        do {
            try fileManager.createDirectory(at: folderURL!, withIntermediateDirectories: true, attributes: nil)
            let fileURL = folderURL?.appendingPathComponent(fileIdentifier)
            try data.write(to: fileURL!, options: [])
            let attachment = try UNNotificationAttachment(identifier: fileIdentifier, url: fileURL!, options: options)
            return attachment
        } catch let error {
            print("error \(error)")
        }
        
        return nil
    }
}
