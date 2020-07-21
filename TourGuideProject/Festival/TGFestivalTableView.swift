//
//  TGFestivalTableView.swift
//  TourGuideProject
//
//  Created by hyunndy on 2020/07/17.
//  Copyright © 2020 hyunndy. All rights reserved.
//

import UIKit

protocol TGFestivalDelegate: class {
    func selected(_ detailInfo: FestivalData)
}

class TGFestivalTableView: UITableView {
    
    // 델리게이트
    weak var tapCellDelegate: TGFestivalDelegate?
    
    // 데이터
    var festivalInfos = Array<FestivalData>()

}

extension TGFestivalTableView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return festivalInfos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TGFestivalCell.reusableIdentifier, for: indexPath) as? TGFestivalCell else {return UITableViewCell()}
        
        if festivalInfos.count > 0 {
            
            cell.then {

                // 행사 제목
                if festivalInfos[indexPath.row].title!.contains("[") {

                    let finalText = NSAttributedString().splitByBracket(festivalInfos[indexPath.row].title!)
                    $0.lbFestivalTitle.attributedText = finalText
                    
                }else {
                    $0.lbFestivalTitle.text = festivalInfos[indexPath.row].title
                }
            
                // 행사 주소
                if let str = festivalInfos[indexPath.row].addr1 {
                    $0.lbFestivalAddr.text = str
                    if let str2 = festivalInfos[indexPath.row].addr2 {
                        $0.lbFestivalAddr.text = str+str2
                    }
                }
                
                // 행사 날짜
                $0.lbFestivalDate.text = String(festivalInfos[indexPath.row].eventstartdate!.changeDateFormat()) + " ~ " + String(festivalInfos[indexPath.row].eventenddate!.changeDateFormat())
                
                // 행사 이미지
                $0.setImageView(festivalInfos[indexPath.row].thumbnail!)
            }
            
        } else {
            cell.lbFestivalTitle.text = "데이터 로드 전"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.frame.height/5
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        tapCellDelegate?.selected(festivalInfos[indexPath.row])
    }
}
