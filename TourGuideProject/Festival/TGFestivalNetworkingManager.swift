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


// 행사 정보를 저장할 구조체
struct FestivalData: Hashable{
    // 제목
    var title: String?
    // 전체 주소
    var addr1: String?
    // 상세 주소
    var addr2: String?
    // 행사 시작일
    var eventstartdate: Int?
    // 행사 종료일
    var eventenddate: Int?
    // 대표 이미지
    var image: String?
    // 썸네일 이미지
    var thumbnail: String?
    // 전화번호
    var tel: String?
}

// API 주소
let FestivalAPI = "http://api.visitkorea.or.kr/openapi/service/rest/KorService/searchFestival?serviceKey="
+ serviceKey
+ "&MobileOS=IOS&pageNo=1&MobileApp=AppTest&arrange=P&listYN=Y&_type=json&numOfRows="
+ String(numOfRows)
+ "&eventStartDate=20200101"




class TGFestivalNetworkingManager: TGNetworkingManager {
    
    // 각 월의 festival 구조체가 들어있는 배열 미리 생성
    var finalArr = Array(repeating: [FestivalData](), count: 12)
    
    override func loadData(update: @escaping (_ a: [Any]?) -> Void) {
        
        var validFestivalInfo = [FestivalData]()
        
        requestAPI(FestivalAPI) { (request) in
            request.responseObject { (response: DataResponse<FestivalInfo>) in
                if let afResult = response.result.value?.response {
                    if let afHead = afResult.head {
                        switch afHead.resultMsg {
                        case "OK":
                            if let afItems = afResult.body?.items?.item {
                                for afItem in afItems {
                                    let newFestivalInfo = FestivalData(title: afItem.title, addr1: afItem.addr1, addr2: afItem.addr2, eventstartdate: afItem.eventstartdate, eventenddate: afItem.eventenddate, image: afItem.image, thumbnail: afItem.thumbnail, tel: afItem.tel)
                                    validFestivalInfo.append(newFestivalInfo)
                                }
                                
                                update(validFestivalInfo)
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
