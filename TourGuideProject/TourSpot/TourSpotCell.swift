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
    
    override func awakeFromNib() {
        super.awakeFromNib()

        self.backgroundColor = .systemGray5
    
        setView()
    }
    
    func setView(){
        
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
            make.bottom.equalTo(-40)
        }
        
        // 이미지
        self.addSubview(ivThumbnail)
        ivThumbnail.then{
            $0.frame = .zero
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
        }.snp.makeConstraints {
            $0.width.equalTo(200)
            $0.top.equalToSuperview().offset(25)
            $0.height.equalTo(125)
            $0.centerX.equalToSuperview()
        }
    }
}
