/*
 파일명: TGDataManager.swift
 작성자: 2020/07/08 유현지

 설멍:
 AlamofireObjectManager 라이브러리를 통한 Json 데이터 파싱에 사용되는 데이터 클래스
 ObjectMapper의 Mappable 프로토콜을 반드시 채택해야함
*/

import Foundation
import ObjectMapper

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
