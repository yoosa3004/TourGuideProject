//
//  TMTourSpot.swift
//  TourGuideProject
//
//  Created by hyunndy on 2020/07/23.
//  Copyright © 2020 hyunndy. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import ObjectMapper

class TMTourSpot: CMNetworking {
    
    var areaCode: Int? = 0
    
    override var APIKey: String {
        let key = "http://api.visitkorea.or.kr/openapi/service/rest/KorService/areaBasedList?serviceKey="
                + serviceKey
                + "&MobileApp=AppTest&MobileOS=IOS&listYN=Y&_type=json&contentTypeId=12"
        return key
    }
    
    override func requestAPI(update: @escaping(_ update: [Any]?) -> Void){
        
        super.request(requestParam: getParam()) { (response:Any?) in
            if let result = Mapper<TourSpotResponse>().map(JSONObject: response) {
                if result.response?.head?.resultMsg == "OK" {
                    if let apiResult = result.response?.body?.items?.item {
                        update(apiResult)
                    } else {
                        tgLog("Tour Data load Failed")
                        update(nil)
                    }
                } else {
                    tgLog("Tour Data LoadingMessage is not OK")
                    update(nil)
                }
            } else {
                tgLog("Tour Data Mapping Failed")
                update(nil)
            }
        }
    }
    
    override func getParam() -> Dictionary<String, Any> {
        
        var param = super.getParam()
        
        if let validAreaCode = areaCode {
            param.updateValue(validAreaCode, forKey: "areaCode")
        }
        
        return param
    }
}
