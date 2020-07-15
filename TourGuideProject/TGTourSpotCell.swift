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
        $0.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFill
    }
    
    // 관광지 제목
    var titleLabel = UILabel().then {
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
        
        self.addSubview(imageView)
        let url =
            
            URL(string: "https://firebasestorage.googleapis.com/v0/b/honggun-blog.appspot.com/o/%E1%84%91%E1%85%B5%E1%84%8F%E1%85%A1%E1%84%8E%E1%85%B2.png?alt=media&token=68c2ffff-81a5-4db9-a67e-b776242cea02")
        
        let processor = DownsamplingImageProcessor(size: imageView.bounds.size)
        imageView.kf.setImage(with: url, options: [.processor(processor)])
        imageView.snp.makeConstraints { (make) -> Void in
            
            make.centerX.equalToSuperview()
            make.top.equalTo(10)
        }
    }

}
