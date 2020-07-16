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
    var imageView = UIImageView().then {
        $0.frame = .zero
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFit
    }
    
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
        // Initialization code
        
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
        
        self.addSubview(imageView)
        imageView.snp.makeConstraints { (make) -> Void in
            make.centerX.equalToSuperview()
            make.top.equalTo(10)
        }
    }
    
    func setImageView(_ url:String) {
        let url = URL(string: url)
        let processor = DownsamplingImageProcessor(size: imageView.bounds.size)
        imageView.kf.setImage(with: url, options: [.processor(processor)])
    }

}
