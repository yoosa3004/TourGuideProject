//
//  FestivalDetailView.swift
//  TourGuideProject
//
//  Created by hyunndy on 2020/07/24.
//  Copyright © 2020 hyunndy. All rights reserved.
//

import UIKit

class FestivalDetailView: UIView {

    // 데이터
    var festivalInfo = FestivalInfo()
    
    var scvFestival = UIScrollView()
    
    var stvFestival = UIStackView()
    
    // 행사 이미지
    var ivFestival = UIImageView()

    // 행사 제목
    var lbTitle = UILabel()

    // 행사 주소
    var lbAddr = UILabel()

    // 행사 전화번호
    var lbTel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setViews() {
        self.setFrameViews()
        self.setContentView()
    }
    
    func setFrameViews() {
        // 스크롤뷰
        self.addSubview(scvFestival)
        scvFestival.then {
            $0.isScrollEnabled = true
            $0.translatesAutoresizingMaskIntoConstraints = false
        }.snp.makeConstraints { [unowned self] in
            $0.left.right.equalToSuperview()
            $0.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            $0.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
        }
        
        // 스택뷰
        self.scvFestival.addSubview(stvFestival)
        stvFestival.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.centerX.top.bottom.equalToSuperview()
            $0.left.right.equalToSuperview()
        }
    }
    
    func setContentView() {
        
        // 행사 이미지
        self.stvFestival.addSubview(ivFestival)
        ivFestival.then {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
            
            if let image = festivalInfo.image {
                $0.kf.setImage(with: URL(string: image), options: nil)
            }
        }.snp.makeConstraints {
            $0.top.equalToSuperview().offset(15)
            $0.left.equalToSuperview().offset(15)
            $0.right.equalToSuperview().offset(-15)
            $0.height.equalTo(300)
        }
        
        // 행사 제목
        self.scvFestival.addSubview(lbTitle)
        lbTitle.then {
            if let title = festivalInfo.title {
                $0.text = title
            }
            $0.textAlignment = .center
            $0.numberOfLines = 0
            $0.lineBreakMode = .byWordWrapping
            $0.font = UIFont.systemFont(ofSize: 18, weight: .regular)
            $0.textColor = .black
            $0.translatesAutoresizingMaskIntoConstraints = false
        }.snp.makeConstraints { [unowned self] in
            $0.top.equalTo(self.ivFestival.snp.bottom).offset(25)
            $0.height.equalTo(25)
            $0.left.equalToSuperview().offset(25)
            $0.right.equalToSuperview().offset(-25)
        }
        
        // 행사 주소
        self.scvFestival.addSubview(lbAddr)
        lbAddr.then {
            if let addr1 = festivalInfo.addr1 {
                $0.text = addr1
                if let addr2 = festivalInfo.addr2 {
                    $0.text = addr1 + addr2
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
        
        // 행사 전화번호
        self.scvFestival.addSubview(lbTel)
        lbTel.then {
            if let tel = festivalInfo.tel {
                $0.text = tel
            }else {
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
