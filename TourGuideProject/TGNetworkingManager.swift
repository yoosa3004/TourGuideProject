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

let serviceKey = "a74NIAcB4Qf%2BtsFyvKMQuUgHtj1GC8P%2Fog5YLsqQJs2kvhfTVrhZGc4NhIYdQJ1dl6U0Sq8DF7srBwrfoZloDA%3D%3D"
let APIUrl = "http://api.visitkorea.or.kr/openapi/service/rest/KorService/areaBasedList?serviceKey="
            + serviceKey
            + "&pageNo=1&numOfRows=10&MobileApp=AppTest&MobileOS=IOS&arrange=O&cat1=&contentTypeId=&areaCode=&sigunguCode=&cat2=&cat3=&listYN=Y&modifiedtime=&_type=json"

class TGNetworkingManager {
    
    // API 통신 후 받아온 json 파일을 변환해 최종적으로 쓰일 데이터에 할당하는 함수
    func loadData() {
        Alamofire.request(APIUrl).responseObject { (response: DataResponse<TourInfo>) in
            if let afResult = response.result.value?.response {
                if let afHead = afResult.head {
                    switch afHead.resultMsg {
                    case "OK":
                        if let tourInfos = afResult.body?.items?.item {
                            for tourInfo in tourInfos {
                                print(tourInfo.title ?? "Data load failed")
                            }
                        }
                    default:
                        print("Data load failed")
                    }
                }
            }
        }
    }
}




