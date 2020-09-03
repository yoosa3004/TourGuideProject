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
import RxCocoa
import RxSwift


class TMFestivals: CMNetworking {
    
    var eventStartDate: Int?
    
    let maxPageNo: Int = 10
    
    // API 로딩 완료 후 최종 데이터만 sections에 넣어주기 위한 임시 배열
    var resultArr = Array(repeating: [FestivalInfo](), count: 12)
    
    override var APIKey: String {
        let key = "http://api.visitkorea.or.kr/openapi/service/rest/KorService/searchFestival?serviceKey="
            + serviceKey
            + "&MobileOS=IOS&MobileApp=AppTest&listYN=Y&_type=json"
        return key
    }
    
        lazy var festivalObservable = BehaviorSubject<[FestivalInfo]?>(value: [])
    
    override init() {
        
        // 현재 날짜부터 조회
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        let currentDate = formatter.string(from: Date())
        self.eventStartDate = Int(currentDate)
    }
    
    /*
     override func requestAPI(update: @escaping(_ update: [Any]?) -> Void){
     super.request(requestParam: getParam()) { (response:Any?) in
     
     if let result = Mapper<FestivalResponse>().map(JSONObject: response) {
     if result.response?.head?.resultMsg == "OK" {
     if let apiResult = result.response?.body?.items?.item {
     update(self.sortByStartDate(apiResult))
     } else {
     tgLog("Festival Data load Failed")
     update(nil)
     }
     } else {
     tgLog("Festival Data loading Message is not OK")
     tgLog(result.response?.head?.resultMsg)
     update(nil)
     }
     } else {
     tgLog("Festival Data Mapping Failed")
     update(nil)
     }
     }
     }
     */
    
    override func requestAPI(update: @escaping(_ update: [Any]?) -> Void) {

        resultArr = Array(repeating: [FestivalInfo](), count: 12)
        
        var observableArr = [Observable<Any?>]()
        
        // maxPageNo 만큼 로드
        for pageNo in 1...maxPageNo {
            self.pageNo = pageNo
            let tempObservable = super.request(requestParam: getParam())
            observableArr.append(tempObservable)
        }
        
        Observable.merge(observableArr)
            .map { json in Mapper<FestivalResponse>().map(JSONObject: json) }
            .filter { json in json?.response?.head?.resultMsg == "OK" }
            .map { result in result?.response?.body?.items?.item }
            .ifEmpty(default: nil)
            .subscribe { event in
                switch event {
                case .next(let result):
                    if let result = result {
                        self.sortByStartDate(result)
                        print("행사 데이터 로드!")
                    }
                    break
                case .error(let err):
                    tgLog(err)
                    update(nil)
                    self.pageNo = 1
                    break
                case .completed:
                    update(self.resultArr)
                    self.pageNo = 1
                    print("행사 데이터 업데이트!")
                    break
                }
        }
        .disposed(by: self.disposeBag)
    }
    
    override func getParam() -> Dictionary<String, Any> {
        
        var param = super.getParam()
        
        if let validStartDate = self.eventStartDate {
            param.updateValue(validStartDate, forKey: "eventStartDate")
        }
        
        return param
    }
    
    // MARK: API로부터 받은 데이터를 날짜순으로 정렬 후 월 단위로 쪼개어 테이블 뷰 데이터에 넣어줄 행사 정보 배열 생성 (1월 행사, 2월 행사, 3월 행사, ...)
    func sortByStartDate(_ targetArr: Array<FestivalInfo>) {
        
        // 월 단위로 쪼개어 적재
        for idx in resultArr.indices {
            
            let month = String.init(format: "%02d", idx+1)
            
            let filteredByMonth = targetArr.filter {
                
                if let startDate = $0.eventstartdate {
                    return startDate >= Int("2020" + month + "01") ?? Int.max && startDate <= Int("2020" + month + "31") ?? Int.min
                }
                
                return false
            }
            
            resultArr[idx].append(contentsOf: filteredByMonth)
        }
    }
}
