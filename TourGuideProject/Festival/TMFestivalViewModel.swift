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

    override func requestAPI(update: @escaping(_ update: [Any]?) -> Void){
        super.request(requestParam: getParam()) { (response:Any?) in
            
            if let result = Mapper<FestivalResponse>().map(JSONObject: response) {
                if result.response?.head?.resultMsg == "OK" {
                    update(result.response?.body?.items?.item)
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
}

