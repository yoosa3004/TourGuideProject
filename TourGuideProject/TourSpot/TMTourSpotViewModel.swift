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

let areaMenu = ["서울", "경기도", "강원도", "전라도", "경상도", "제주도"]
let areaMenuCode: Array<Int> = [1,31,32,37,36,39]

class TMTourSpots: TMNetworking {
    
    var areaCode: Int? = 0
    
    override var APIKey: String {
        get {
            let key = "http://api.visitkorea.or.kr/openapi/service/rest/KorService/areaBasedList?serviceKey="
                     + serviceKey
                     + "&MobileApp=AppTest&MobileOS=IOS&listYN=Y&_type=json&contentTypeId=12"
            return key
        }
        set {
        }
    }
    
    override func requestAPI(update: @escaping(_ update: [Any]?) -> Void){
        super.request(requestParam: getParam()) { (response:Any?) in
            if let result = Mapper<TourResponse>().map(JSONObject: response) {
                update(result.response?.body?.items?.item)
            } else {
                print("Tour Data load Failed")
            }
        }
    }
    
    override func getParam() -> Dictionary<String, Any> {
        
        var param = super.getParam()
        
        if areaCode != nil {
            param.updateValue(areaCode!, forKey: "areaCode")
        }
        
        return param
    }

    
}
