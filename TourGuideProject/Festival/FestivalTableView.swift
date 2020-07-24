//
//  TGFestivalTableView.swift
//  TourGuideProject
//
//  Created by hyunndy on 2020/07/17.
//  Copyright © 2020 hyunndy. All rights reserved.
//

import UIKit

protocol FestivalDelegate: class {
    func selected(_ detailInfo: FestivalData)
}

class FestivalTableView: UITableView {
    
    // 델리게이트
    weak var tapCellDelegate: FestivalDelegate?
    
    // MARK: 최종 데이터
    var festivalInfo = Array(repeating: [FestivalData](), count: 12)
}



extension FestivalTableView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return festivalInfo[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FestivalCell.reusableIdentifier, for: indexPath) as? FestivalCell else {return UITableViewCell()}
        
        // MARK: 섹션별로 나누기 작업
        // 셀 세팅
        if festivalInfo[indexPath.section].count > 0 {
            cell.then {
                let cellData = festivalInfo[indexPath.section][indexPath.row]
                
                // 행사 제목
                if cellData.title!.contains("[") {
                    
                    let finalText = NSAttributedString().splitByBracket(cellData.title!)
                    $0.lbFestivalTitle.attributedText = finalText
                } else {
                    $0.lbFestivalTitle.text = cellData.title
                }
             
                // 행사 주소
                if let str = cellData.addr1 {
                    $0.lbFestivalAddr.text = str
                    if let str2 = cellData.addr2 {
                        $0.lbFestivalAddr.text = str+str2
                    }
                }
                
                // 행사 날짜
                $0.lbFestivalDate.text = String(cellData.eventstartdate!.changeDateFormat()) + " ~ " + String(cellData.eventenddate!.changeDateFormat())
                
                // 행사 이미지
                $0.setImageView(cellData.thumbnail!)
            }
        }
        
        return cell
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.frame.height/5
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        tapCellDelegate?.selected(festivalInfo[indexPath.section][indexPath.row])
    }
    
    // 섹션 갯수
    func numberOfSections(in tableView: UITableView) -> Int {
        return 12
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if festivalInfo[section].count == 0 {
            return CGFloat.leastNormalMagnitude
        } else {
            return 40
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 40))
        view.backgroundColor = .systemGray5
        
        let ivHeader = UIImageView()
        view.addSubview(ivHeader)
        ivHeader.then {
            $0.image = UIImage(named: "happiness.png")
        }.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.top.bottom.equalToSuperview()
        }
        
        let lbHeader = UILabel()
        view.addSubview(lbHeader)
        lbHeader.then {
            $0.text = "\(section+1)월"
            $0.textAlignment = .center
            $0.textColor = .black
        }.snp.makeConstraints {
            $0.left.equalTo(ivHeader.snp.right).offset(10)
            $0.top.bottom.equalToSuperview()
        }
        
        return view
    }
}
