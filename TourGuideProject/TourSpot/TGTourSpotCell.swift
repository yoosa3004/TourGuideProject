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

class TGTourSpotCell: UICollectionViewCell {

    // 관광지 이미지
    var imageView = UIImageView()
    
    // 관광지 제목
    var titleLabel = UILabel().then {
        $0.text = "관광지 제목"
        $0.textAlignment = .center
        $0.adjustsFontSizeToFitWidth = true
        $0.numberOfLines = 0
        $0.lineBreakMode = .byWordWrapping
        $0.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        $0.textColor = .black
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

        self.backgroundColor = .lightGray
    
        setView()
    }
    
    func setView(){
        
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) -> Void in
            make.centerX.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalTo(-40)
        }
        
        // 이미지
        self.addSubview(imageView)
        imageView.then{
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
    
    func setImageView(_ url:String) {
        let url = URL(string: url)
        imageView.kf.setImage(with: url, options: nil)//[.processor(processor)])
    }

}
