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

class TGTourSpotCell: UICollectionViewCell {

    // 관광지 이미지
    
    // 관광지 제목
    let titleLabel = UILabel().then {
        $0.text = "관광지 제목"
        $0.textAlignment = .center
        $0.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        $0.textColor = .black
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.backgroundColor = .yellow
        
        setView()
    }
    
    func setView(){
        
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) -> Void in
            
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-40)
        }
    }

}
