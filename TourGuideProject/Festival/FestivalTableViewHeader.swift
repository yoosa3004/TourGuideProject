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
         
         // Content View
         contentView.backgroundColor = .systemGray5//UIColor(hex: 0x2E3944)
         
         // Image View
         contentView.addSubview(ivHeader)
         ivHeader.then {
             $0.translatesAutoresizingMaskIntoConstraints = false
         }.snp.makeConstraints {
             $0.left.equalTo(contentView.layoutMarginsGuide.snp.left)
             $0.centerY.equalTo(contentView.layoutMarginsGuide)
         }
         
         // Title Label
         contentView.addSubview(lbTitle)
         lbTitle.then {
             $0.translatesAutoresizingMaskIntoConstraints = false
         }.snp.makeConstraints {
             $0.top.equalTo(contentView.layoutMarginsGuide)
             $0.left.equalTo(ivHeader.snp.right).offset(15)
         }
         
         // Arrow Label
         contentView.addSubview(ivArrow)
         ivArrow.then {
             $0.translatesAutoresizingMaskIntoConstraints = false
             $0.image = UIImage(named: "up_and_down.png")?.withRenderingMode(.alwaysOriginal)
         }.snp.makeConstraints {
             $0.top.equalTo(contentView.layoutMarginsGuide)
             $0.right.equalTo(contentView.layoutMarginsGuide).offset(-15)
         }
         
         // call tapHeader when tappinh on this header
         addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapHeader(_:))))
     }

    @objc func tapHeader(_ gestureRecognizer: UITapGestureRecognizer) {
        guard let cell = gestureRecognizer.view as? FestivalTableViewHeader else { return }
        
        delegate?.toggleSection(self, section: cell.section)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
