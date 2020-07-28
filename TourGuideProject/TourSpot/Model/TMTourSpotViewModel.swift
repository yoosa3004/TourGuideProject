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

class TMTourSpot: TMNetworking {
    
    var areaCode: Int? = 0
    
    override var APIKey: String {
        let key = "http://api.visitkorea.or.kr/openapi/service/rest/KorService/areaBasedList?serviceKey="
                + serviceKey
                + "&MobileApp=AppTest&MobileOS=IOS&listYN=Y&_type=json&contentTypeId=12"
        return key
    }
    
    // ** print 로그를 debug와 release 에 따라 출력 다르게 되게.
    override func requestAPI(update: @escaping(_ update: [Any]?) -> Void){
        
        super.request(requestParam: getParam()) { (response:Any?) in
            if let result = Mapper<TourSpotResponse>().map(JSONObject: response) {
                if result.response?.head?.resultMsg == "OK" {
                    update(result.response?.body?.items?.item)
                } else {
                    tgLog("Tour Data load Failed")
                    update(nil)
                }
            } else {
                tgLog("Tour Data load Failed")
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
