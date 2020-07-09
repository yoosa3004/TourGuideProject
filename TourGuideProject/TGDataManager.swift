/*
 파일명: TGDataManager.swift
 작성자: 2020/07/08 유현지

 설멍:
 AlamofireObjectManager 라이브러리를 통한 Json 데이터 파싱에 사용되는 데이터 클래스
 ObjectMapper의 Mappable 프로토콜을 반드시 채택해야함
*/

import Foundation
import ObjectMapper

// 관광지 정보를 저장할 구조체 ( 구조체, 클래스 고민이 되는데 일단 상속 필요없고, callbyvalue 오버헤드 걱정될만한 크기가 아니므로 일단 구조체 )
struct TourData: Hashable{
    // 제목
    var title: String?
    // 지역 코드
    var areaCode: Int?
    // 전체 주소
    var addr1: String?
    // 상세 주소
    var addr2: String?
    // 대표 이미지
    var image: String?
    // 전화번호
    var tel: String?
    // 관광지코드 (관광지, 숙박, 행사 등)
    var contenttypeid: Int?
}

// 최종적으로 사용할 DataSet.
var tourInfos = Set<TourData>()


// json 파싱을 위한 class
//---------------------------------------------------------------------------
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
    
    //-- 부가 정보
    // 지역 코드
    var areaCode: Int?
    // 전체 주소
    var addr1: String?
    // 상세 주소
    var addr2: String?
    // 대표 이미지
    var image: String?
    // 전화번호
    var tel: String?
    //--
    
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
        tel <- map["tel"]
    }
}
//---------------------------------------------------------------------------


