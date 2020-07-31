//
//  TourSpotModel.swift
//  TourGuideProject
//
//  Created by hyunndy on 2020/07/23.
//  Copyright © 2020 hyunndy. All rights reserved.
//

import Foundation
import ObjectMapper

// 각 지역 별 관광지를 받아오기 위한 API 요청 변수(areaCode)에 들어갈 Dictionary
let areaCategory = ["서울": 1, "경기도": 31, "강원도": 32, "충청도": 34, "경상도": 36, "전라도": 37, "제주도": 39].sorted { (first, second) -> Bool in return first.value < second.value }

// 관광지 데이터 JSON Mapping Class
class TourSpotResponse: Mappable {
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
        var item: [TourSpotInfo]?
        
        required init?(map: Map) {
        }
        
        func mapping(map: Map) {
            item <- map["item"]
        }
    }
}

// JSON Mapping 후 최종적으로 쓰이게될 데이터
class TourSpotInfo: Mappable {
    
    //-- 필수 응답 변수
    var contentid: Int?
    var contenttypeid: Int?
    var createdtime: Int?
    var modifiedtime: Int?
    var title: String?
    
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
    
    init() {}
    
    init(title: String?) {
        self.title = title
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        contentid <- map["contentid"]
        contenttypeid <- map["contenttypeid"]
        createdtime <- map["createdtime"]
        modifiedtime <- map["modifiedtime"]
        title <- map["title"]
        
        areaCode <- map["areacode"]
        addr1 <- map["addr1"]
        addr2 <- map["addr2"]
        image <- map["firstimage"]
        thumbnail <- map["firstimage2"]
        tel <- map["tel"]
    }
}
