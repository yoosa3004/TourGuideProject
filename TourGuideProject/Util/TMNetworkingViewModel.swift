/*

파일명: TGNetworkingManager.swift
작성자: 2020/07/08 유현지

설명:
AlamofireObjectMapper 라이브러리를 통한 API 통신 + Json 파일을 받아 TGDataManager에 있는 데이터 형식으로 변환하는 작업을 하는 클래스.
*/
 
import Foundation
import Alamofire
import AlamofireObjectMapper
import ObjectMapper



class TMNetworking {

    let serviceKey = "tLN%2Bjilj3ZFHA2%2FpssG4J4hN82oI6Q2b0rF3pB5hrv3LVOccCkbBP2YcHlMqd7%2FqHejXWPsU0abYZ2y%2FnivcZQ%3D%3D"
    
    var pageNo: Int? = 1
    var numOfRows: Int? = 2
    var arrange: String?
    
    var APIKey = ""
    
    func requestAPI(update: @escaping(_ update: [Any]?) -> Void) {}
    
    func request(requestParam: Dictionary<String, Any>, update: @escaping(_ update: Any?) -> Void) {
        
        var urlString = APIKey
        for (key, value) in requestParam {
            urlString += "&\(key)=\(value)"
        }
        
        Alamofire.request(urlString).responseJSON { response in
            if response.result.isSuccess {
                update(response.result.value)
            }
        }
    }
    
    func getParam() -> Dictionary<String, Any> {
        
        var param = Dictionary<String, Any>()
        
        if let actualpageNo = pageNo {
             param.updateValue(actualpageNo, forKey: "pageNo")
        }
        
        if numOfRows != nil {
            param.updateValue(numOfRows!, forKey: "numOfRows")
        }
        
        if arrange != nil {
            param.updateValue(arrange!, forKey: "arrange")
        }
        
        return param
    }
}

