//
//  TMFestivalModel.swift
//  TourGuideProject
//
//  Created by hyunndy on 2020/07/23.
//  Copyright © 2020 hyunndy. All rights reserved.
//

import Foundation
import ObjectMapper

// 행사 관련 JSON 매핑을 위한 클래스
class FestivalResponse: Mappable {
    var response: ResponseInfo?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        response <- map["response"]
    }

    class ResponseInfo: Mappable {
        var head: HeadInfo?
        var body: BodyInfo?
        
        
        required init?(map: Map) {
        }
        
        func mapping(map: Map) {
            head <- map["header"]
            body <- map["body"]
        }
    }
    
    class HeadInfo: Mappable {
        var resultCode: String?
        var resultMsg: String?
        
        required init?(map: Map) {
        }
        
        func mapping(map: Map) {
            resultCode <- map["resultCode"]
            resultMsg <- map["resultMsg"]
        }
    }
    
    class BodyInfo: Mappable {
        var items: ItemsInfo?
        var numOfRows: Int?
        var pageNo: Int?
        var totalCount: Int?
        
        required init?(map: Map) {
        }
        
        func mapping(map: Map) {
            items <- map["items"]
            numOfRows <- map["numOfRows"]
            pageNo <- map["pageNo"]
            totalCount <- map["totalCount"]
        }
    }
    
    class ItemsInfo: Mappable {
        var item: [FestivalInfo]?
        
        required init?(map: Map) {
        }
        
        func mapping(map: Map) {
            item <- map["item"]
        }
    }
}

// 최종적으로 사용할 행사 정보 클래스
class FestivalInfo: Mappable {
    
    // 필수 요청 변수
    var contenttypeid: Int?
    var createdtime: Int?
    var modifiedtime: Int?
    var title: String?
    var eventstartdate: Int?
    var eventenddate: Int?
    
    
    // 고유 식별자
    var contentid: Int?
    // 지역 코드
    var areaCode: Int?
    // 전체 주소
    var addr1: String?
    // 상세 주소
    var addr2: String?
    // 대표 이미지
    var image: String?
    // 썸네일
    var thumbnail: String?
    // 전화번호
    var tel: String?
    
    // DB 저장용 ( YYYY.MM.DD ~ YYYY.MM.DD )
    var convertedEventDate: String?
    
    init() {}
    
    init(title: String?, addr1: String?, addr2: String?, image: String?, thumbnail: String?, tel: String?, eventDate: String?) {
        self.title = title
        
        if let addr1 = addr1 {
            self.addr1 = addr1
            if let addr2 = addr2 {
                self.addr1 = addr1 + addr2
            }
        }
        self.image = image
        self.thumbnail = thumbnail
        self.tel = tel
        
        self.convertedEventDate = eventDate
    }
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        contentid <- map["contentid"]
        contenttypeid <- map["contenttypeid"]
        createdtime <- map["createdtime"]
        modifiedtime <- map["modifiedtime"]
        title <- map["title"]
        eventstartdate <- map["eventstartdate"]
        eventenddate <- map["eventenddate"]
        
        areaCode <- map["areacode"]
        addr1 <- map["addr1"]
        addr2 <- map["addr2"]
        image <- map["firstimage"]
        thumbnail <- map["firstimage2"]
        tel <- map["tel"]
    }
}

