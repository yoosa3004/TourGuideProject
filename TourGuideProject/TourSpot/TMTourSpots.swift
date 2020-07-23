//
//  TMTourSpots.swift
//  TourGuideProject
//
//  Created by hyunndy on 2020/07/23.
//  Copyright © 2020 hyunndy. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import ObjectMapper

let TourAPI = "http://api.visitkorea.or.kr/openapi/service/rest/KorService/areaBasedList?serviceKey="
            + serviceKey
            + "&MobileApp=AppTest&MobileOS=IOS&listYN=Y&_type=json&contentTypeId=12&areaCode="

let areaMenu = ["서울", "경기도", "강원도", "전라도", "경상도", "제주도"]
let areaMenuCode: Array<Int> = [1,31,32,37,36,39]

class TMTourSpots: TMNetworking {
    
    var areaCode = 0
    
    override func loadData(update: @escaping ([Any]?) -> Void) {
        request(numOfRows: 2, arrange: "Q") { (request) in
            request.responseObject { (response: DataResponse<TourResponse>) in
                if let afResult = response.result.value?.response {
                    if let afHead = afResult.head {
                        switch afHead.resultMsg {
                        case "OK":
                            if let afItems = afResult.body?.items?.item {
                                update(afItems)
                            } else {
                                print("Tour Data is Empty")
                                update(nil)
                            }
                        default:
                            print("Tour Data load failed")
                            update(nil)
                        }
                    }
                }
            }
        }
    }
    
    override func getAPIKey() -> String {
        return TourAPI + String(self.areaCode)
    }
}

// 관광지 데이터 json 파싱을 위한 class
//---------------------------------------------------------------------------
// API 통신 후 받는 json 파일
class TourResponse: Mappable {
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
    var item: [TourData]?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        item <- map["item"]
    }
}

// "body" - "item" <아이템> - 최종적으로 쓰이게될 데이터
class TourData: Mappable {
    
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
    // 썸네일
    var thumbnail: String?
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
        thumbnail <- map["firstimage2"]
        tel <- map["tel"]
    }
}
//---------------------------------------------------------------------------
