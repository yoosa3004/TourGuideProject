//
//  TGFestivalTableView.swift
//  TourGuideProject
//
//  Created by hyunndy on 2020/07/17.
//  Copyright © 2020 hyunndy. All rights reserved.
//

import UIKit
import Kingfisher

protocol FestivalDelegate: class {
    func selected(_ detailInfo: FestivalInfo)
}

class FestivalTableView: UITableView {
    
    weak var tapCellDelegate: FestivalDelegate?

    var listFestivalInfo = Array(repeating: [FestivalInfo](), count: 12)
    
    
}

extension FestivalTableView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listFestivalInfo[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cclFestivalInfo = tableView.dequeueReusableCell(withIdentifier: FestivalCell.reusableIdentifier, for: indexPath) as? FestivalCell else {return UITableViewCell()}

        // 셀 세팅
        if listFestivalInfo[indexPath.section].count > 0 {
            return cclFestivalInfo.then {
                let data = listFestivalInfo[indexPath.section][indexPath.row]
                
                // 행사 제목
                if let title = data.title {
                    if title.contains("[") {
                        $0.lbTitle.attributedText = NSAttributedString().splitByBracket(title)
                    } else {
                       $0.lbTitle.text = title
                    }
                }

                // 행사 주소
                if let str = data.addr1 {
                    $0.lbAddr.text = str
                    if let str2 = data.addr2 {
                        $0.lbAddr.text = str+str2
                    }
                }
                
                // 행사 날짜
                if let startDate = data.eventstartdate {
                    if let endDate = data.eventenddate {
                        $0.lbDate.text = String(startDate.changeDateFormat()) + " ~ " + String(endDate.changeDateFormat())
                    }
                }
                
                // 행사 이미지
                if let thumbnail = data.thumbnail {
                    $0.ivFestival.kf.setImage(with: URL(string: thumbnail), options: nil)
                }
            }
        } else {
            return cclFestivalInfo
        }
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.frame.height/5
    }
    
    // 셀 클릭시 델리게이트 호출
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if listFestivalInfo.count > 0 {
            tapCellDelegate?.selected(listFestivalInfo[indexPath.section][indexPath.row])
        }
    }
    
    // 섹션 갯수
    func numberOfSections(in tableView: UITableView) -> Int {
        return 12
    }
    
    // 행사가 없는 달의 섹션은 보이지 않게함
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if listFestivalInfo[section].count == 0 {
            return CGFloat.leastNormalMagnitude
        } else {
            return 40
        }
    }
    
    // 헤더 뷰
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 40))
        view.backgroundColor = .systemGray5
        
        let ivHeader = UIImageView()
        view.addSubview(ivHeader)
        ivHeader.then {
            $0.image = UIImage(named: "happiness.png")
        }.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.centerY.equalToSuperview()
            //$0.top.bottom.equalToSuperview()
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
