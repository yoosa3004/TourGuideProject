//
//  TGFestivalTableView.swift
//  TourGuideProject
//
//  Created by hyunndy on 2020/07/17.
//  Copyright © 2020 hyunndy. All rights reserved.
//

import UIKit

class TGFestivalTableView: UITableView {
    
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
                // 제목
                $0.lbFestivalTitle.text = festivalInfos[indexPath.row].title
                // 주소
                if let str = festivalInfos[indexPath.row].addr1 {
                    $0.lbFestivalAddr.text = str
                    if let str2 = festivalInfos[indexPath.row].addr2 {
                        $0.lbFestivalAddr.text = str+str2
                    }
                }
                //날짜
                $0.lbFestivalDate.text = String(festivalInfos[indexPath.row].eventstartdate!.changeDateFormat()) + " ~ " + String(festivalInfos[indexPath.row].eventenddate!.changeDateFormat())
                //이미지
//                $0.ivFestival.image = UIImage(named: festivalInfos[indexPath.row].thumbnail!)
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
}
