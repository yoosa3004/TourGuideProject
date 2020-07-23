//
//  TMFestivalModel.swift
//  TourGuideProject
//
//  Created by hyunndy on 2020/07/23.
//  Copyright © 2020 hyunndy. All rights reserved.
//

import Foundation
import ObjectMapper

// 행사 데이터 json 파싱을 위한 class
//---------------------------------------------------------------------------
class FestivalResponse: Mappable {
    var response: ResponseInfo2?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        response <- map["response"]
    }
}
// "response"
class ResponseInfo2: Mappable {
    var head: HeadInfo2?
    var body: BodyInfo2?
    
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        head <- map["header"]
        body <- map["body"]
    }
}

// "header" -> header에서 받는 응답코드 / 응답메세지로 데이터 로드 성공/실패 구분 가능
class HeadInfo2: Mappable {
    var resultCode: String?
    var resultMsg: String?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        resultCode <- map["resultCode"]
        resultMsg <- map["resultMsg"]
    }
}

class BodyInfo2: Mappable {
    var items: ItemsInfo2?
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

// "body" - "items" <아이템 목록>
class ItemsInfo2: Mappable {
    var item: [FestivalData]?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        item <- map["item"]
    }
    
}

// "body" - "item" <아이템> - 최종적으로 쓰이게될 데이터
class FestivalData: Mappable {
    
    required init?(map: Map) {}
    
    //-- 필수 정보
    var contentid: Int?
    var contenttypeid: Int?
    var createdtime: Int?
    var modifiedtime: Int?
    var title: String?
    var eventstartdate: Int?
    var eventenddate: Int?
    //--
    
    //-- 부가 정보
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
    //--
    
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
//---------------------------------------------------------------------------

