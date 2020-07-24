//
//  TGFestivalCell.swift
//  TourGuideProject
//
//  Created by hyunndy on 2020/07/17.
//  Copyright © 2020 hyunndy. All rights reserved.
//

import UIKit
import Kingfisher


class FestivalCell: UITableViewCell {

    // 행사 이미지
    let ivFestival = UIImageView()
    
    // 행사 이름
    let lbFestivalTitle = UILabel()
    
    // 행사 주소
    let lbFestivalAddr = UILabel()
    
    // 행사 일정
    let lbFestivalDate = UILabel()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setUpViews()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setUpViews() {
        
        // 행사 이미지
        self.addSubview(self.ivFestival)
        ivFestival.then { [unowned self] in
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
        }.snp.makeConstraints {
            $0.left.equalToSuperview().offset(25)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(150)
            $0.height.equalTo(100) // 10*view.frame.width/320(SE해상도)
        }
        
        // 행사 이름
        self.addSubview(self.lbFestivalTitle)
        self.lbFestivalTitle.then {
            $0.text = "행사 이름란"
            $0.textColor = .black
            $0.textAlignment = .left
        }.snp.makeConstraints { [unowned self] in
            $0.left.equalTo(self.ivFestival.snp.right).offset(15)
            $0.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(20)
            $0.right.equalToSuperview().offset(-20)
        }
        
        // 행사 주소
        self.addSubview(self.lbFestivalAddr)
        self.lbFestivalAddr.then {
            $0.text = "행사 주소란"
            $0.textColor = .black
            $0.textAlignment = .left
        }.snp.makeConstraints { [unowned self] in
            $0.top.equalTo(self.lbFestivalTitle.snp.bottom).offset(10)
            $0.left.equalTo(self.lbFestivalTitle.snp.left)
            $0.right.equalTo(self.lbFestivalTitle)
        }
        
        // 행사 일정란
        self.addSubview(self.lbFestivalDate)
        self.lbFestivalDate.then {
            $0.text = "2020.05.05"+"~"+"2020.05.10"
            $0.textColor = .black
            $0.textAlignment = .left
        }.snp.makeConstraints { [unowned self] in
            $0.top.equalTo(self.lbFestivalAddr.snp.bottom).offset(10)
            $0.left.equalTo(self.lbFestivalTitle.snp.left)
            $0.right.equalTo(self.lbFestivalTitle)
        }
    }
    
    // KingFisher를 통한 이미지 세팅
    func setImageView(_ url:String) {
        let url = URL(string: url)
        let processor = DownsamplingImageProcessor(size: CGSize(width: 150, height: 100))
        ivFestival.kf.setImage(with: url, options: [.processor(processor)])
    }
}
