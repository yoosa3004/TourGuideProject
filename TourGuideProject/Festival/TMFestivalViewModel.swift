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


class TMFestivals: TMNetworking {
    
    var eventStartDate: Int? = 202001010
  
    override var APIKey: String {
        let key = "http://api.visitkorea.or.kr/openapi/service/rest/KorService/searchFestival?serviceKey="
                  + serviceKey
                  + "&MobileOS=IOS&MobileApp=AppTest&listYN=Y&_type=json"
        return key
    }

    override func requestAPI(update: @escaping(_ update: [Any]?) -> Void){
        super.request(requestParam: getParam()) { (response:Any?) in
            
            if let result = Mapper<FestivalResponse>().map(JSONObject: response) {
                if result.response?.head?.resultMsg == "OK" {
                    if let apiResult = result.response?.body?.items?.item {
                        update(self.sortByStartDate(apiResult))
                    } else {
                        print("Festival Data Mapping Failed")
                        update(nil)
                    }
                } else {
                    print("Festival Data load Failed")
                    update(nil)
                }
            } else {
                print("Festival Data load Failed")
            }
        }
    }
    
    override func getParam() -> Dictionary<String, Any> {
        
        var param = super.getParam()
        
        if let validStartDate = eventStartDate {
            param.updateValue(validStartDate, forKey: "eventStartDate")
        }
        
        return param
    }
    
        // MARK: API로부터 받은 데이터를 날짜순으로 정렬 후 월 단위로 쪼개어 테이블 뷰 데이터에 넣어줄 행사 정보 배열 생성 (1월 행사, 2월 행사, 3월 행사, ...)
    func sortByStartDate(_ targetArr: Array<FestivalInfo>) -> [[FestivalInfo]] { //update: @escaping(_ a: [[FestivalInfo]]) -> Void) {
            
            var sortedArr = Array(repeating: [FestivalInfo](), count: 12)
            var tempArr = targetArr
            
            // 날짜순 정렬
            tempArr.sort { (left: FestivalInfo, right:FestivalInfo) -> Bool in
                
                return left.eventstartdate! < right.eventstartdate!
            }
            
            // 월 단위로 쪼개어 적재
            for idx in 0 ... 8 {
                
                let test = "2020" + "0" + String(idx+1)
                
                let arr = tempArr.filter {
                    $0.eventstartdate! >= Int(test+"01")! && $0.eventstartdate! <= Int(test+"31")!
                }
                
                sortedArr[idx].append(contentsOf: arr)
            }
            
            for idx in 9 ... 11 {
                
                let test = "2020" + String(idx+1)
                
                let arr = tempArr.filter {
                    $0.eventstartdate! >= Int(test+"01")! && $0.eventstartdate! <= Int(test+"31")!
                }
                
                sortedArr[idx].append(contentsOf: arr)
            }

            return sortedArr
    }
}
