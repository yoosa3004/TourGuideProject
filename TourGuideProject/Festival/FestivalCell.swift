//
//  TGFestivalCell.swift
//  TourGuideProject
//
//  Created by hyunndy on 2020/07/17.
//  Copyright © 2020 hyunndy. All rights reserved.
//

import UIKit
import Kingfisher


class FestivalCell: UITableViewCell {

    let ivFestival = UIImageView()
    
    let lbTitle = UILabel()
    
    let lbAddr = UILabel()
    
    let lbDate = UILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setUpViews()
    }
    
    func setUpViews() {
        
        // 행사 이미지
        self.addSubview(self.ivFestival)
        ivFestival.then {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
        }.snp.makeConstraints {
            $0.left.equalToSuperview().offset(25)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(150)
            $0.height.equalTo(100)
        }
        
        // 행사 이름
        self.addSubview(self.lbTitle)
        self.lbTitle.then {
            $0.textColor = .black
            $0.textAlignment = .left
        }.snp.makeConstraints { [unowned self] in
            $0.right.equalToSuperview().offset(-20)
            $0.left.equalTo(self.ivFestival.snp.right).offset(15)
            $0.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(20)
        }
        
        // 행사 주소
        self.addSubview(self.lbAddr)
        self.lbAddr.then {
            $0.textColor = .black
            $0.textAlignment = .left
        }.snp.makeConstraints { [unowned self] in
            $0.top.equalTo(self.lbTitle.snp.bottom).offset(10)
            $0.left.right.equalTo(self.lbTitle)
        }
        
        // 행사 일정란
        self.addSubview(self.lbDate)
        self.lbDate.then {
            $0.textColor = .black
            $0.textAlignment = .left
        }.snp.makeConstraints { [unowned self] in
            $0.top.equalTo(self.lbAddr.snp.bottom).offset(10)
            $0.left.right.equalTo(self.lbTitle)
        }
    }
}
