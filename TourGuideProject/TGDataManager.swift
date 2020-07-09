/*
 파일명: TGDataManager.swift
 작성자: 2020/07/08 유현지

 설멍:
 AlamofireObjectManager 라이브러리를 통한 Json 데이터 파싱에 사용되는 데이터 클래스
 ObjectMapper의 Mappable 프로토콜을 반드시 채택해야함
*/

import Foundation
import ObjectMapper

// API 통신 후 받는 json 파일
class TourInfo: Mappable {
    var response: ResponseInfo?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        response <- map["response"]
    }
}

// "response"
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

// "header" -> header에서 받는 응답코드 / 응답메세지로 데이터 로드 성공/실패 구분 가능
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

// "body"
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

// "body" - "items" <아이템 목록>
class ItemsInfo: Mappable {
    var item: [ItemInfo]?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        item <- map["item"]
    }
    
}

// "body" - "item" <아이템> - 최종적으로 쓰이게될 데이터
class ItemInfo: Mappable {
    
    //-- 필수 정보
    var contentid: Int?
    var contenttypeid: Int?
    var createdtime: Int?
    var modifiedtime: Int?
    var title: String?
    //--
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        contentid <- map["contentid"]
        contenttypeid <- map["contenttypeid"]
        createdtime <- map["createdtime"]
        modifiedtime <- map["modifiedtime"]
        title <- map["title"]
    }
}


