//
//  DrawerTableViewCell.swift
//  TourGuideProject
//
//  Created by hyunndy on 2020/08/05.
//  Copyright © 2020 hyunndy. All rights reserved.
//

import UIKit

class DrawerTableViewCell: UITableViewCell {

    let ivDrawer = UIImageView()
    
    let lbTitle = UILabel()
    
    let lbAddr = UILabel()
    
    let lbDate = UILabel()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    
        setUpViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    func setUpViews() {
        
        // 행사 이미지
        self.addSubview(self.ivDrawer)
        ivDrawer.then {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
        }.snp.makeConstraints {
            $0.width.equalTo(ivDrawer.snp.height).multipliedBy(1.5)
            $0.height.equalToSuperview().multipliedBy(0.7)
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(10)
        }
        
        // 행사 이름
        self.addSubview(self.lbTitle)
        self.lbTitle.then {
            $0.textColor = .black
            $0.textAlignment = .left
        }.snp.makeConstraints { [unowned self] in
            $0.right.equalToSuperview().offset(-20)
            $0.left.equalTo(self.ivDrawer.snp.right).offset(15)
            $0.top.equalTo(self.ivDrawer.snp.top).offset(5)
        }
        
        // 행사 주소
        self.addSubview(self.lbAddr)
        self.lbAddr.then {
            $0.textColor = .black
            $0.textAlignment = .left
        }.snp.makeConstraints { [unowned self] in
            $0.left.right.equalTo(self.lbTitle)
            $0.top.equalTo(self.lbTitle.snp.bottom)
            $0.height.equalToSuperview().dividedBy(3)
        }
        
        // 행사 일정란
        self.addSubview(self.lbDate)
        self.lbDate.then {
            $0.textColor = .black
            $0.textAlignment = .left
        }.snp.makeConstraints { [unowned self] in
            $0.top.equalTo(self.lbAddr.snp.bottom)
            $0.left.right.equalTo(self.lbTitle)
        }
    }
    
}
