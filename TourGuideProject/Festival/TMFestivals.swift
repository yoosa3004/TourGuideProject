//
//  TGFestivalNetworkingManager.swift
//  TourGuideProject
//
//  Created by hyunndy on 2020/07/22.
//  Copyright © 2020 hyunndy. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import ObjectMapper

let FestivalAPI = "http://api.visitkorea.or.kr/openapi/service/rest/KorService/searchFestival?serviceKey="
                + serviceKey
                + "&MobileOS=IOS&MobileApp=AppTest&listYN=Y&_type=json&eventStartDate="


class TMFestivals: TMNetworking {
    
    var eventStartDate = 20200101
    
    // 각 월의 festival 구조체가 들어있는 배열 미리 생성
    var finalArr = Array(repeating: [FestivalData](), count: 12)
    
    override func loadData(update: @escaping (_ a: [Any]?) -> Void) {
        request(numOfRows: 2, arrange: "P") { (request) in
            request.responseObject { (response: DataResponse<FestivalResponse>) in
                if let afResult = response.result.value?.response {
                    if let afHead = afResult.head {
                        switch afHead.resultMsg {
                        case "OK":
                            if let afItems = afResult.body?.items?.item {
                                update(afItems)
                            } else {
                               print("Festival Data is Empty")
                               update(nil)
                            }
                        default:
                            print("Festival Data load Failed")
                            update(nil)
                        }
                    }
                }
            }
        }
    }
    
    override func getAPIKey() -> String {
        return FestivalAPI + String(self.eventStartDate)
    }
    
    func sortByDate(_ targetArr: Array<FestivalData>, update: @escaping(_ a: [[FestivalData]]) -> Void) {
        
        var tempArr = targetArr
 
        // 3-1. 날짜순 정렬
        tempArr.sort { (left: FestivalData, right:FestivalData) -> Bool in
            
            return left.eventstartdate! < right.eventstartdate!
        }
        
        // 3-2. filter로 날짜순으로 정렬해서 final에 적재
        for idx in 0 ... 8 {
            
            // 이 달에 포함되는지
            let test = "2020" + "0" + String(idx+1)
            
            let arr = tempArr.filter {
                // 시작일이 이 날 보다 작은 날이면 이 월에 열리는 행사
                $0.eventstartdate! >= Int(test+"01")! && $0.eventstartdate! <= Int(test+"31")!
            }
            
            // 3-3. 배열로 추가
            finalArr[idx].append(contentsOf: arr)
        }
        
        for idx in 9 ... 11 {
            
            let test = "2020" + String(idx+1)
            
            let arr = tempArr.filter {
                $0.eventstartdate! >= Int(test+"01")! && $0.eventstartdate! <= Int(test+"31")!
            }
            
            finalArr[idx].append(contentsOf: arr)
        }
        
        update(finalArr)
    }
}

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

