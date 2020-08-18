//
//  CMDBModel.swift
//  TourGuideProject
//
//  Created by hyunndy on 2020/08/18.
//  Copyright © 2020 hyunndy. All rights reserved.
//

import Foundation

// MARK: Firebase DB에 올라가는 찜리스트 데이터 클래스
class ZZimListInfo {
    
    // Firebase로부터 Data 읽어올 때 Dictionary 형태로 받기 때문에 그 데이터로 초기화
    init(dictionary: [String: Any]) {
        self.contentId = dictionary["contentid"] as? String
        self.addr = dictionary["addr"] as? String
        self.eventDate = dictionary["eventdate"] as? String
        self.image = dictionary["image"] as? String
        self.tel = dictionary["tel"] as? String
        self.thumbNail = dictionary["thumbnail"] as? String
        self.title = dictionary["title"] as? String
    }
    
    init(contentId: String?, image: String?, thumbNail: String?, title: String?, addr: String?, tel: String?, eventDate: String?) {
        self.contentId = contentId
        self.image = image
        self.thumbNail = thumbNail
        self.title = title
        self.addr = addr
        self.tel = tel
        self.eventDate = eventDate
    }
    
    let contentId: String?
    let image: String?
    let thumbNail: String?
    let title: String?
    let addr: String?
    let tel: String?
    let eventDate: String?
    
    // 관광지/행사 데이터타입
    var dataType: String = ""
}
