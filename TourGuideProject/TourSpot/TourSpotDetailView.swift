//
//  TourSpotDetailView.swift
//  TourGuideProject
//
//  Created by hyunndy on 2020/07/24.
//  Copyright © 2020 hyunndy. All rights reserved.
//

import UIKit

class TourSpotDetailView: UIView {

    // 데이터
    var tourSpotInfo = TourSpotInfo()
    
    // 스크롤뷰
    let scvDetailTourSpot = UIScrollView()
    
    // 스택뷰
    let stvDetailTourSpot = UIStackView()

    // 이미지뷰
    var ivTourSpot = UIImageView()
    
    // 제목
    var lbTitle = UILabel()
    
    // 주소(addr1 + addr2)
    var lbAddr = UILabel()
    
    // 전화번호
    var lbTel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setViews() {
        self.setFrameViews()
        self.setContentViews()
    }
    
    func setFrameViews() {
        
        self.addSubview(scvDetailTourSpot)
        scvDetailTourSpot.then {
            $0.isScrollEnabled = true
            $0.translatesAutoresizingMaskIntoConstraints = false
        }.snp.makeConstraints { [unowned self] in
            $0.left.right.equalToSuperview()
            $0.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            $0.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
        }

        self.scvDetailTourSpot.addSubview(stvDetailTourSpot)
        stvDetailTourSpot.snp.makeConstraints {
            $0.centerX.width.equalToSuperview()
            $0.top.bottom.equalToSuperview()
            $0.left.right.equalToSuperview()
        }
    }

    func setContentViews() {
        
        // 이미지
        self.stvDetailTourSpot.addSubview(ivTourSpot)
        ivTourSpot.then {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
            if let image = tourSpotInfo.image {
                $0.kf.setImage(with: URL(string: image), options: nil)
            }
        }.snp.makeConstraints {
            $0.top.equalToSuperview().offset(15)
            $0.left.equalToSuperview().offset(15)
            $0.right.equalToSuperview().offset(-15)
            $0.height.equalTo(300)
        }
        
        // 제목
        self.stvDetailTourSpot.addSubview(lbTitle)
        lbTitle.then {
            if let title = tourSpotInfo.title {
                $0.text = title
            }
            $0.textAlignment = .center
            $0.numberOfLines = 0
            $0.lineBreakMode = .byWordWrapping
            $0.font = UIFont.systemFont(ofSize: 18, weight: .regular)
            $0.textColor = .black
            $0.translatesAutoresizingMaskIntoConstraints = false
        }.snp.makeConstraints { [unowned self] in
            $0.top.equalTo(self.ivTourSpot.snp.bottom).offset(25)
            $0.height.equalTo(25)
            $0.left.equalToSuperview().offset(25)
            $0.right.equalToSuperview().offset(-25)
        }
        
        // 주소
        self.stvDetailTourSpot.addSubview(lbAddr)
        lbAddr.then {
            if let addr1 = tourSpotInfo.addr1 {
                $0.text = addr1
                if let addr2 = tourSpotInfo.addr2 {
                    $0.text = addr1+addr2
                }
            }
            $0.textAlignment = .center
            $0.numberOfLines = 0
            $0.lineBreakMode = .byWordWrapping
            $0.font = UIFont.systemFont(ofSize: 18, weight: .regular)
            $0.textColor = .black
            $0.translatesAutoresizingMaskIntoConstraints = false
        }.snp.makeConstraints { [unowned self] in
            $0.left.right.equalTo(self.lbTitle)
            $0.top.equalTo(self.lbTitle.snp.bottom).offset(25)
        }
        
        // 전화번호
        self.stvDetailTourSpot.addSubview(lbTel)
        lbTel.then {
            if let tel = tourSpotInfo.tel {
                $0.text = tel
            } else {
                $0.text = "전화번호가 제공되지 않습니다."
                $0.textColor = .systemGray4
            }
            $0.textAlignment = .center
            $0.numberOfLines = 0
            $0.lineBreakMode = .byWordWrapping
            $0.font = UIFont.systemFont(ofSize: 18, weight: .regular)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }.snp.makeConstraints { [unowned self] in
            $0.left.right.equalTo(self.lbAddr)
            $0.top.equalTo(self.lbAddr.snp.bottom).offset(25)
            $0.bottom.equalToSuperview()
        }
    }
    
    
}
