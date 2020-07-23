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

let serviceKey = "tLN%2Bjilj3ZFHA2%2FpssG4J4hN82oI6Q2b0rF3pB5hrv3LVOccCkbBP2YcHlMqd7%2FqHejXWPsU0abYZ2y%2FnivcZQ%3D%3D"

class TMNetworking {
    
    // MARK: 실제 Controller에서 호출할 함수
    func loadData(update: @escaping (_ a: [Any]?) -> Void) {}

    // MARK: request(불러올 페이지 번호, 한 페이지당 갯수(최대:10개), 정렬타입)
    func request(_ pageNo: Int = 1, numOfRows: Int, arrange: String, update: @escaping (_ a: DataRequest) -> Void) {
        
        let URL = getAPIKey() + "&numOfRows=\(numOfRows)&pageNo=\(pageNo)&arrange=\(arrange)"
        update(Alamofire.request(URL))
    }
    
    // MARK: 관광지, 행사 개별 API 요청변수 세팅
    func getAPIKey() -> String {
        return ""
    }
}

