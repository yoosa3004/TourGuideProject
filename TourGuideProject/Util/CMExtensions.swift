//
//  TGExtensions.swift
//  TourGuideProject
//
//  Created by hyunndy on 2020/07/23.
//  Copyright © 2020 hyunndy. All rights reserved.
//

import Foundation
import UIKit
import KYDrawerController
import YYBottomSheet

extension NSObject {
    static var reusableIdentifier: String {
        return String(describing: self)
    }
}

// 20201515 -> 2015.15.15 변환 익스텐션
extension Int {
    func changeDateFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        let tempDate = dateFormatter.date(from: String(self))
        
        dateFormatter.dateFormat = "yyyy.MM.dd"

        if let Date = tempDate {
            return dateFormatter.string(from: Date)
        } else {
            return ""
        }
    }
}

// 문자에 "[ ]"가 있을 시 "[ ]" 안의 문자를 bold+red 처리
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

extension UIViewController {
    func setDrawer() {
        self.tabBarController?.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "drawer.png")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(tabDrawerIcon(_:)) )
    }
    
    @objc func tabDrawerIcon(_ sender: UIBarButtonItem) {
        if let drawerController = self.navigationController?.parent as? KYDrawerController {
            drawerController.setDrawerState(.opened, animated: true)
        }
    }
}

public func tgLog(_ str: Any) {
    #if DEBUG
    print(str)
    #else
    #endif
}

extension String {
    func showToast() {
        let option: [YYBottomSheet.SimpleToastOptions:Any] = [
            .showDuration: 2.0,
            .backgroundColor: UIColor.black,
            .beginningAlpha: 0.8,
            .messageFont: UIFont.italicSystemFont(ofSize: 15),
            .messageColor: UIColor.white
        ]
        
        let simpleToast = YYBottomSheet.init(simpleToastMessage: self, options: option)
        
        simpleToast.show()
    }
}
