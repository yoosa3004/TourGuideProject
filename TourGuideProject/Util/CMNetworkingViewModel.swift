import Foundation
import Alamofire
import AlamofireObjectMapper
import ObjectMapper

class CMNetworking {

    let serviceKey = "tLN%2Bjilj3ZFHA2%2FpssG4J4hN82oI6Q2b0rF3pB5hrv3LVOccCkbBP2YcHlMqd7%2FqHejXWPsU0abYZ2y%2FnivcZQ%3D%3D"
    
    var pageNo: Int = 1
    var numOfRows: Int = 10
    var arrange: String?
    
    var APIKey: String {
        return ""
    }
    
    func requestAPI(update: @escaping(_ update: [Any]?) -> Void) {}
    
    func request(requestParam: Dictionary<String, Any>, update: @escaping(_ update: Any?) -> Void) {
        
        var urlString = APIKey
        for (key, value) in requestParam {
            urlString += "&\(key)=\(value)"
        }
        
        Alamofire.request(urlString).responseJSON { response in
            if response.result.isSuccess {
                update(response.result.value)
            } else {
                tgLog("API Networing Failed")
                update(nil)
            }
        }
    }
    
    func getParam() -> Dictionary<String, Any> {
        
        var param = Dictionary<String, Any>()
        
        param.updateValue(pageNo, forKey: "pageNo")
        
        param.updateValue(numOfRows, forKey: "numOfRows")

        if let validarrange = arrange {
            param.updateValue(validarrange, forKey: "arrange")
        }
        
        return param
    }
}

