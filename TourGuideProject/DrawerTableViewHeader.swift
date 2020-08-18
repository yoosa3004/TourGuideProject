//
//  DrawerTableViewHeader.swift
//  TourGuideProject
//
//  Created by hyunndy on 2020/08/06.
//  Copyright © 2020 hyunndy. All rights reserved.
//

import UIKit

protocol DrawerTableViewHeaderDelegate {
    func toggleSelection(_ header: DrawerTableViewHeader, section: Int)
}

class DrawerTableViewHeader: UITableViewHeaderFooterView {
    
    var delegate: DrawerTableViewHeaderDelegate?
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
            $0.top.bottom.equalTo(contentView.layoutMarginsGuide)
            $0.left.equalTo(ivHeader.snp.right).offset(15)
        }
        
        contentView.addSubview(ivArrow)
        ivArrow.then {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.image = UIImage(named: "up_and_down.png")?.withRenderingMode(.alwaysOriginal)
        }.snp.makeConstraints {
            $0.top.equalTo(contentView.layoutMarginsGuide)
            $0.right.equalTo(contentView.layoutMarginsGuide).offset(-15)
        }
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapHeader(_:))))
    }
    
    @objc func tapHeader(_ gestureRecognizer: UITapGestureRecognizer) {
        guard let cell = gestureRecognizer.view as? DrawerTableViewHeader else { return }
        
        delegate?.toggleSelection(self, section: cell.section)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
