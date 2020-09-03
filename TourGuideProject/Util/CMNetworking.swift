import Foundation
import Alamofire
import AlamofireObjectMapper
import ObjectMapper
import RxSwift
import RxCocoa

/*
 RxCocoa
 
 UIBinding
 메인스레드에있어야하고, 에러가 나도 스트림이 죽으면 안된다.
 
 Observable / Subject
 Observable / Driver
 
 */

class CMNetworking {

    let serviceKey = "tLN%2Bjilj3ZFHA2%2FpssG4J4hN82oI6Q2b0rF3pB5hrv3LVOccCkbBP2YcHlMqd7%2FqHejXWPsU0abYZ2y%2FnivcZQ%3D%3D"
    
    var pageNo: Int = 1
    var numOfRows: Int = 10
    var arrange: String = "P"
    
    var APIKey: String {
        return ""
    }
    
    var disposeBag = DisposeBag()
    
    func requestAPI(update: @escaping(_ update: [Any]?) -> Void) {}
    
    func request(requestParam: Dictionary<String, Any>) -> Observable<Any?> {
        var urlString = APIKey
        for (key, value) in requestParam {
            urlString += "&\(key)=\(value)"
        }
        
        return Observable<Any?>.create { observer in
            _ = Alamofire.request(urlString).responseJSON { response in
                if response.result.isSuccess {
                    observer.onNext(response.result.value)
                    observer.onCompleted()
                } else {
                    if let err = response.error {
                        observer.onError(err)
                    } else {
                        observer.onNext(nil)
                        observer.onCompleted()
                    }
                }
            }
            return Disposables.create()
        }
    }
    
    func getParam() -> Dictionary<String, Any> {
        
        var param = Dictionary<String, Any>()
        
        param.updateValue(pageNo, forKey: "pageNo")
        
        param.updateValue(numOfRows, forKey: "numOfRows")

        param.updateValue(arrange, forKey: "arrange")
        
        return param
    }
    
    /*
    func request(requestParam: Dictionary<String, Any>, update: @escaping(_ update: Any?) -> Void) {
        
        var urlString = APIKey
        for (key, value) in requestParam {
            urlString += "&\(key)=\(value)"
        }
        
        print("\(self.pageNo)번째 요청")
        Alamofire.request(urlString).responseJSON { response in
            if response.result.isSuccess {
                update(response.result.value)
            } else {
                tgLog("API Networing Failed")
                update(nil)
            }
        }
    }
     */
}

