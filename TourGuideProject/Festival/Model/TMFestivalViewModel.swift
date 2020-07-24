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
        get {
            let key = "http://api.visitkorea.or.kr/openapi/service/rest/KorService/searchFestival?serviceKey="
                     + serviceKey
                     + "&MobileOS=IOS&MobileApp=AppTest&listYN=Y&_type=json"
            return key
        }
        set {
        }
    }
    
    // 각 월의 festival 구조체가 들어있는 배열 미리 생성
    var finalArr = Array(repeating: [FestivalData](), count: 12)

    override func requestAPI(update: @escaping(_ update: [Any]?) -> Void){
        super.request(requestParam: getParam()) { (response:Any?) in
            if let result = Mapper<FestivalResponse>().map(JSONObject: response) {
                update(result.response?.body?.items?.item)
            } else {
                print("Festival Data load Failed")
            }
        }
    }
    
    override func getParam() -> Dictionary<String, Any> {
        
        var param = super.getParam()
        
        if eventStartDate != nil {
            param.updateValue(eventStartDate!, forKey: "eventStartDate")
        }
        
        return param
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

