//
//  TGFestivalNetworkingManager.swift
//  TourGuideProject
//
//  Created by hyunndy on 2020/07/22.
//  Copyright © 2020 hyunndy. All rights reserved.
//

import Foundation


// 행사 정보를 저장할 구조체
struct FestivalData: Hashable{
    // 제목
    var title: String?
    // 전체 주소
    var addr1: String?
    // 상세 주소
    var addr2: String?
    // 행사 시작일
    var eventstartdate: Int?
    // 행사 종료일
    var eventenddate: Int?
    // 대표 이미지
    var image: String?
    // 썸네일 이미지
    var thumbnail: String?
    // 전화번호
    var tel: String?
}

// API 주소
let FestivalAPI = "http://api.visitkorea.or.kr/openapi/service/rest/KorService/searchFestival?serviceKey="
+ serviceKey
+ "&MobileOS=IOS&pageNo=1&MobileApp=AppTest&arrange=P&listYN=Y&_type=json&numOfRows="
+ String(numOfRows)
+ "&eventStartDate=20200101"




class TGFestivalNetworkingManager: TGNetworkingManager {
    
    // API 통신으로 얻은 데이터
    //var tempArr = [FestivalData]()

    // 각 월의 festival 구조체가 들어있는 배열 미리 생성
    var finalArr = Array(repeating: [FestivalData](), count: 12)
        
    // MARK: TEST
    func getTempArr() -> Array<FestivalData> {
        
        // API 통신으로 얻은 데이터
        var tempArr = [FestivalData]()
        
        tempArr.append(FestivalData(title: "1월", addr1: "", addr2: "", eventstartdate: 20200115, eventenddate: 20200116, image: "", thumbnail: "", tel: ""))
        tempArr.append(FestivalData(title: "2월", addr1: "", addr2: "", eventstartdate: 20200215, eventenddate: 20200216, image: "", thumbnail: "", tel: ""))
        tempArr.append(FestivalData(title: "3월", addr1: "", addr2: "", eventstartdate: 20200315, eventenddate: 20200316, image: "", thumbnail: "", tel: ""))
        tempArr.append(FestivalData(title: "4월", addr1: "", addr2: "", eventstartdate: 20200415, eventenddate: 20200416, image: "", thumbnail: "", tel: ""))
        tempArr.append(FestivalData(title: "5월", addr1: "", addr2: "", eventstartdate: 20200515, eventenddate: 20200516, image: "", thumbnail: "", tel: ""))
        tempArr.append(FestivalData(title: "6월", addr1: "", addr2: "", eventstartdate: 20200615, eventenddate: 20200616, image: "", thumbnail: "", tel: ""))
        tempArr.append(FestivalData(title: "7월", addr1: "", addr2: "", eventstartdate: 20200715, eventenddate: 20200716, image: "", thumbnail: "", tel: ""))
        tempArr.append(FestivalData(title: "8월", addr1: "", addr2: "", eventstartdate: 20200815, eventenddate: 20200816, image: "", thumbnail: "", tel: ""))
    
        return tempArr
    }
    
    
    func sortByDate(_ targetArr: Array<FestivalData>, update: @escaping(_ a: [[FestivalData]]) -> Void) {
        
        var tempArr = targetArr//getTempArr()
 
        // 3-1. 날짜순 정렬
        tempArr.sort { (left: FestivalData, right:FestivalData) -> Bool in
            
            return left.eventstartdate! < right.eventstartdate!
        }
        
        // 3-2. filter로 날짜순으로 정렬해서 final에 적재
        for idx in 0 ... 8 {
            
            // 이 달에 포함되는지
            let test = "2020" + "0" + String(idx+1)
            
            let arr = tempArr.filter {
                // 시작일이 이 날 보다 작은 날이면 이 월에 열리는 행사
                $0.eventstartdate! >= Int(test+"01")! && $0.eventstartdate! <= Int(test+"31")!
            }
            
            // 3-3. 배열로 추가
            finalArr[idx].append(contentsOf: arr)
        }
        
        for idx in 9 ... 11 {
            
            let test = "2020" + String(idx+1)
            
            let arr = tempArr.filter {
                $0.eventstartdate! >= Int(test+"01")! && $0.eventstartdate! <= Int(test+"31")!
            }
            
            finalArr[idx].append(contentsOf: arr)
        }
        /*
        for idx in finalArr.indices {
            print("-----------------------------------")
            print(finalArr[idx])
            print("-----------------------------------")
        }
 */
        
        update(finalArr)
    }
    
}
