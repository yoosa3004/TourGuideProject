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
import RxSwift

class TMTourSpot: CMNetworking {
    
    var areaCode: Int? = 0
    let maxPageNo: Int = 10
    
    override var APIKey: String {
        let key = "http://api.visitkorea.or.kr/openapi/service/rest/KorService/areaBasedList?serviceKey="
            + serviceKey
            + "&MobileApp=AppTest&MobileOS=IOS&listYN=Y&_type=json&contentTypeId=12"
        return key
    }
    
    
    lazy var tourSpotObservable = BehaviorSubject<[TourSpotInfo]>(value: [])
    
    override init() {
        super.init()
        
//        requestAPIRx()
        
    }
    
    func requestAPIRx() {
        
        _ = super.request(requestParam: getParam())
            .map { json in Mapper<TourSpotResponse>().map(JSONObject: json)}
            .filter { json in json?.response?.head?.resultMsg == "OK" }
            .map { result in
                print("@@@@@@@@@ \(result?.response?.body?.items?.item)")
                
                return (result?.response?.body?.items?.item ?? [])
        }
            .take(1)
            .bind(to: tourSpotObservable)
        
        
        print(tourSpotObservable)
    }

    
    override func requestAPI(update: @escaping(_ update: [Any]?) -> Void) {
        
        let observable = super.request(requestParam: getParam())
        observable
            .map { json in Mapper<TourSpotResponse>().map(JSONObject: json)}
            .filter { json in json?.response?.head?.resultMsg == "OK" }
            .map { result in result?.response?.body?.items?.item }
            .ifEmpty(default: nil)
            .subscribe { event in
                switch event {
                case .next(let result):
                    if let result = result {
                        update(result)
                    }
                    break
                case .error(let err):
                    tgLog(err)
                    update(nil)
                    break
                case .completed:
                    break
                }
        }
        .disposed(by: self.disposeBag)
    }
    
    override func getParam() -> Dictionary<String, Any> {
        
        var param = super.getParam()
        
        if let validAreaCode = areaCode {
            param.updateValue(validAreaCode, forKey: "areaCode")
        }
        
        return param
    }
    
    
    /*
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
     */
}
