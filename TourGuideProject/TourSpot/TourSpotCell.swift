//
//  TGTourSpotCellCollectionViewCell.swift
//  TourGuideProject
//
//  Created by hyunndy on 2020/07/14.
//  Copyright © 2020 hyunndy. All rights reserved.
//

import UIKit
import Then
import SnapKit
import Kingfisher

class TourSpotCell: UICollectionViewCell {
    
    let ivThumbnail = UIImageView()

    let lbTitle = UILabel()
    

    override init(frame: CGRect) {
        super.init(frame: frame)
    
        self.backgroundColor = .systemGray5
        setView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setView(){
        
        self.addSubview(ivThumbnail)
        ivThumbnail.then{
            $0.frame = .zero
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
        }.snp.makeConstraints {
            $0.width.equalToSuperview().multipliedBy(0.8)
            $0.height.equalTo(ivThumbnail.snp.width).multipliedBy(0.6)
            $0.top.equalToSuperview().offset(25)
            $0.centerX.equalToSuperview()
        }
        
        self.addSubview(lbTitle)
        lbTitle.then {
            $0.textAlignment = .center
            $0.numberOfLines = 1
            $0.lineBreakMode = .byTruncatingTail
            $0.font = UIFont.systemFont(ofSize: 18, weight: .regular)
            $0.textColor = .black
            $0.translatesAutoresizingMaskIntoConstraints = false
        }.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.top.equalTo(ivThumbnail.snp.bottom)
            make.bottom.equalToSuperview()
        }
    }
}
