/*
 파일명: TGDataManager.swift
 작성자: 2020/07/08 유현지

 설멍:
 AlamofireObjectManager 라이브러리를 통한 Json 데이터 파싱에 사용되는 데이터 클래스
 ObjectMapper의 Mappable 프로토콜을 반드시 채택해야함
*/

import Foundation
import ObjectMapper

class TGMappable: Mappable {
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
    }
}


// 관광지 정보를 저장할 구조체 ( 구조체, 클래스 고민이 되는데 일단 상속 필요없고, callbyvalue 오버헤드 걱정될만한 크기가 아니므로 일단 구조체 )

struct TourData: Hashable {
    // 제목
    var title: String?
    // 지역 코드
    var areaCode: Int?
    // 전체 주소
    var addr1: String?
    // 상세 주소
    var addr2: String?
    // 대표 이미지
    var image: String?
    // 썸네일 이미지
    var thumbnail: String?
    // 전화번호
    var tel: String?
    // 관광지코드 (관광지, 숙박, 행사 등)
    var contenttypeid: Int?
}


let areaMenu = ["서울", "경기도", "강원도", "전라도", "경상도", "제주도"]
let areaMenuCode: Array<Int> = [1,31,32,37,36,39]
//---------------------------------------------------------------------------

// 관광지 데이터 json 파싱을 위한 class
//---------------------------------------------------------------------------
// API 통신 후 받는 json 파일
class TourInfo: TGMappable {
    var response: ResponseInfo?
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        response <- map["response"]
    }
}

// "response"
class ResponseInfo: Mappable {
    var head: HeadInfo?
    var body: BodyInfo?
    
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        head <- map["header"]
        body <- map["body"]
    }
}

// "header" -> header에서 받는 응답코드 / 응답메세지로 데이터 로드 성공/실패 구분 가능
class HeadInfo: Mappable {
    var resultCode: String?
    var resultMsg: String?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        resultCode <- map["resultCode"]
        resultMsg <- map["resultMsg"]
    }
}

// "body"
class BodyInfo: Mappable {
    var items: ItemsInfo?
    var numOfRows: Int?
    var pageNo: Int?
    var totalCount: Int?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        items <- map["items"]
        numOfRows <- map["numOfRows"]
        pageNo <- map["pageNo"]
        totalCount <- map["totalCount"]
    }
}

// "body" - "items" <아이템 목록>
class ItemsInfo: Mappable {
    var item: [ItemInfo]?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        item <- map["item"]
    }
    
}

// "body" - "item" <아이템> - 최종적으로 쓰이게될 데이터
class ItemInfo: Mappable {
    
    //-- 필수 정보
    var contentid: Int?
    var contenttypeid: Int?
    var createdtime: Int?
    var modifiedtime: Int?
    var title: String?
    //--
    
    //-- 부가 정보
    // 지역 코드
    var areaCode: Int?
    // 전체 주소
    var addr1: String?
    // 상세 주소
    var addr2: String?
    // 대표 이미지
    var image: String?
    // 썸네일
    var thumbnail: String?
    // 전화번호
    var tel: String?
    //--
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        contentid <- map["contentid"]
        contenttypeid <- map["contenttypeid"]
        createdtime <- map["createdtime"]
        modifiedtime <- map["modifiedtime"]
        title <- map["title"]
        
        areaCode <- map["areacode"]
        addr1 <- map["addr1"]
        addr2 <- map["addr2"]
        image <- map["firstimage"]
        thumbnail <- map["firstimage2"]
        tel <- map["tel"]
    }
}
//---------------------------------------------------------------------------


// 행사 데이터 json 파싱을 위한 class
//---------------------------------------------------------------------------
class FestivalInfo: TGMappable {
    var response: ResponseInfo2?
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        response <- map["response"]
    }
}

// "response"
class ResponseInfo2: Mappable {
    var head: HeadInfo2?
    var body: BodyInfo2?
    
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        head <- map["header"]
        body <- map["body"]
    }
}

// "header" -> header에서 받는 응답코드 / 응답메세지로 데이터 로드 성공/실패 구분 가능
class HeadInfo2: Mappable {
    var resultCode: String?
    var resultMsg: String?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        resultCode <- map["resultCode"]
        resultMsg <- map["resultMsg"]
    }
}

class BodyInfo2: Mappable {
    var items: ItemsInfo2?
    var numOfRows: Int?
    var pageNo: Int?
    var totalCount: Int?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        items <- map["items"]
        numOfRows <- map["numOfRows"]
        pageNo <- map["pageNo"]
        totalCount <- map["totalCount"]
    }
}

// "body" - "items" <아이템 목록>
class ItemsInfo2: Mappable {
    var item: [ItemInfo2]?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        item <- map["item"]
    }
    
}

// "body" - "item" <아이템> - 최종적으로 쓰이게될 데이터
class ItemInfo2: Mappable {
    
    //-- 필수 정보
    var contentid: Int?
    var contenttypeid: Int?
    var createdtime: Int?
    var modifiedtime: Int?
    var title: String?
    var eventstartdate: Int?
    var eventenddate: Int?
    //--
    
    //-- 부가 정보
    // 지역 코드
    var areaCode: Int?
    // 전체 주소
    var addr1: String?
    // 상세 주소
    var addr2: String?
    // 대표 이미지
    var image: String?
    // 썸네일
    var thumbnail: String?
    // 전화번호
    var tel: String?
    //--
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        contentid <- map["contentid"]
        contenttypeid <- map["contenttypeid"]
        createdtime <- map["createdtime"]
        modifiedtime <- map["modifiedtime"]
        title <- map["title"]
        eventstartdate <- map["eventstartdate"]
        eventenddate <- map["eventenddate"]
        
        areaCode <- map["areacode"]
        addr1 <- map["addr1"]
        addr2 <- map["addr2"]
        image <- map["firstimage"]
        thumbnail <- map["firstimage2"]
        tel <- map["tel"]
    }
}

// 20201515 -> 2015.15.15 변환 익스텐션
extension Int {
    func changeDateFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        let tempDate = dateFormatter.date(from: String(self))
        
        dateFormatter.dateFormat = "yyyy.MM.dd"

        if tempDate != nil {
            return dateFormatter.string(from: tempDate!)
        }else {
            return ""
        }
    }
}

// 이미지 크기 변환 익스텐션
extension UIImage {
    func resized(to size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}

// 타이틀에 "[ ]"가 있을 시 "[ ]" 안의 문자를 bold 처리
extension NSAttributedString {
    
    func splitByBracket(_ text: String) -> NSAttributedString? {

        let arr = text.components(separatedBy: "[")[1].components(separatedBy: "]")
        let finalText = NSMutableAttributedString()
        .bold(arr[0], fontSize: 15)
        .normal(arr[1], fontSize: 15)
        
        return finalText
    }
 
}

extension NSMutableAttributedString {
    func bold(_ text: String, fontSize: CGFloat) -> NSMutableAttributedString {
        let blackattrs: [NSAttributedString.Key: Any] = [.font: UIFont.boldSystemFont(ofSize: fontSize)]
        let redattrs: [NSAttributedString.Key: Any] = [.font: UIFont.boldSystemFont(ofSize: fontSize), .foregroundColor:UIColor(red: 1, green: 0, blue: 0, alpha: 1)]
        self.append(NSMutableAttributedString(string: "[", attributes: blackattrs))
        self.append(NSMutableAttributedString(string: text, attributes: redattrs))
        self.append(NSMutableAttributedString(string: "]", attributes: blackattrs))
        return self
    }

    func normal(_ text: String, fontSize: CGFloat) -> NSMutableAttributedString {
        let attrs: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: fontSize)]
        self.append(NSMutableAttributedString(string: text, attributes: attrs))
        return self
    }
}
