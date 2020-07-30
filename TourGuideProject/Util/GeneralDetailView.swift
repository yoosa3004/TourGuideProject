//
//  GeneralDetailView.swift
//  TourGuideProject
//
//  Created by hyunndy on 2020/07/30.
//  Copyright © 2020 hyunndy. All rights reserved.
//

import UIKit

class GeneralDetailView: UIView {
    
    var scvDetail = UIScrollView()
    
    var stvDetail = UIStackView()
    
    var ivDetail = UIImageView()
    
    var lbTitle = UILabel()
    
    var lbAddr = UILabel()
    
    var lbTel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setViews() {
        setFrameView()
        setContentView()
    }
    
    func setTypeOfData(_ deliveredInfo: Any?) {
        
        switch deliveredInfo {
        case is FestivalInfo:
            if let detailInfo = deliveredInfo as? FestivalInfo {
                 // set 행사 상세 뷰
                self.setContents(image: detailInfo.image, title: detailInfo.title, addr1: detailInfo.addr1, addr2: detailInfo.addr2, tel: detailInfo.tel)
            }
        case is TourSpotInfo:
            if let detailInfo = deliveredInfo as? TourSpotInfo {
                // set 관광지 상세 뷰
                self.setContents(image: detailInfo.image, title: detailInfo.title, addr1: detailInfo.addr1, addr2: detailInfo.addr2, tel: detailInfo.tel)
            }
        default:
            tgLog("상세 페이지 데이터 로드 실패")
        }
    }
    
    func setContents(image: String?, title: String?, addr1: String?, addr2: String?, tel: String?) {
    
        // 이미지
        if let image = image {
            ivDetail.kf.setImage(with: URL(string: image), options: nil)
        }
        
        // 제목
        if let title = title {
            lbTitle.text = title
        }
        
        // 주소
        if let addr1 = addr1 {
            lbAddr.text = addr1
            if let addr2 = addr2 {
                lbAddr.text = addr1 + addr2
            }
        }
        
        // 전화번호
        if let tel = tel {
            lbTel.text = tel
        } else {
            lbTel.text = "전화번호가 제공되지 않습니다."
            lbTel.textColor = .systemGray4
        }
    }
    
    func setFrameView() {
        
        // 스크롤뷰
        self.addSubview(scvDetail)
        scvDetail.then {
            $0.isScrollEnabled = true
            $0.translatesAutoresizingMaskIntoConstraints = false
        }.snp.makeConstraints { [unowned self] in
            $0.left.right.equalToSuperview()
            $0.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            $0.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
        }
        
        // 스택뷰
        self.scvDetail.addSubview(stvDetail)
        stvDetail.then {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.axis = .horizontal
            $0.distribution = .fillEqually
            $0.alignment = .fill
        }.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.centerX.top.bottom.equalToSuperview()
            $0.left.right.equalToSuperview()
        }
    }
    
    func setContentView() {
        
        // 상세 이미지
        self.stvDetail.addSubview(ivDetail)
        ivDetail.then {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
        }.snp.makeConstraints {
            $0.top.equalToSuperview().offset(15)
            $0.left.equalToSuperview().offset(15)
            $0.right.equalToSuperview().offset(-15)
            $0.height.equalTo(300)
        }
        
        // 상세 제목
        self.scvDetail.addSubview(lbTitle)
        lbTitle.then {
            $0.textAlignment = .center
            $0.numberOfLines = 0
            $0.lineBreakMode = .byWordWrapping
            $0.font = UIFont.systemFont(ofSize: 18, weight: .regular)
            $0.textColor = .black
            $0.translatesAutoresizingMaskIntoConstraints = false
        }.snp.makeConstraints { [unowned self] in
            $0.top.equalTo(self.ivDetail.snp.bottom).offset(25)
            $0.height.equalTo(25)
            $0.left.equalToSuperview().offset(25)
            $0.right.equalToSuperview().offset(-25)
        }
        
        // 상세 주소
        self.scvDetail.addSubview(lbAddr)
         lbAddr.then {
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
        self.scvDetail.addSubview(lbTel)
        lbTel.then {
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
