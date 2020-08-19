//
//  FestivalTableViewHeader.swift
//  TourGuideProject
//
//  Created by hyunndy on 2020/08/18.
//  Copyright © 2020 hyunndy. All rights reserved.
//

import UIKit

protocol FestivalTableViewHeaderDelegate {
    func toggleSection(_ header: FestivalTableViewHeader, section: Int)
}

class FestivalTableViewHeader: UITableViewHeaderFooterView {

    var delegate: FestivalTableViewHeaderDelegate?
    var section: Int = 0
    
    let ivHeader = UIImageView()
    let lbTitle = UILabel()
    let ivArrow = UIImageView()
    
    override init(reuseIdentifier: String?) {
         super.init(reuseIdentifier: reuseIdentifier)
         
         contentView.backgroundColor = .systemGray5
         
         contentView.addSubview(ivHeader)
         ivHeader.then {
             $0.translatesAutoresizingMaskIntoConstraints = false
         }.snp.makeConstraints {
             $0.left.equalTo(contentView.layoutMarginsGuide.snp.left)
             $0.centerY.equalTo(contentView.layoutMarginsGuide)
         }
         
         contentView.addSubview(lbTitle)
         lbTitle.then {
             $0.translatesAutoresizingMaskIntoConstraints = false
         }.snp.makeConstraints {
             $0.top.equalTo(contentView.layoutMarginsGuide)
             $0.left.equalTo(ivHeader.snp.right).offset(15)
         }
         
         contentView.addSubview(ivArrow)
         ivArrow.then {
             $0.translatesAutoresizingMaskIntoConstraints = false
             $0.image = UIImage(named: "up_and_down.png")?.withRenderingMode(.alwaysOriginal)
         }.snp.makeConstraints {
             $0.centerY.equalTo(contentView.layoutMarginsGuide)
             $0.right.equalTo(contentView.layoutMarginsGuide).offset(-15)
         }
         
         // 헤더 클릭 시 섹션 접었다 폈다하는 함수 호출
         addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapHeader(_:))))
     }

    @objc func tapHeader(_ gestureRecognizer: UITapGestureRecognizer) {
        guard let header = gestureRecognizer.view as? FestivalTableViewHeader else { return }
        
        delegate?.toggleSection(self, section: header.section)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
