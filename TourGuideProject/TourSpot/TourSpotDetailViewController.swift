//
//  TGTourSpotDetailViewController.swift
//  TourGuideProject
//
//  Created by hyunndy on 2020/07/16.
//  Copyright © 2020 hyunndy. All rights reserved.
//

import UIKit
import Then
import SnapKit
import Kingfisher

class TourSpotDetailViewController: UIViewController {

    // 스크롤뷰
    let scvDetailTourSpot = UIScrollView()
    
    // 스택뷰
    let stvDetailTourSpot = UIStackView()

    // 데이터
    var tourSpotInfo = TourSpotInfo()
    
    // 이미지뷰
    var ivTourSpot = UIImageView()
    
    // 제목
    var lbTitle = UILabel()
    
    // 주소(addr1 + addr2)
    var lbAddr = UILabel()
    
    // 전화번호
    var lbTel = UILabel()
    
    // 찜 아이콘
    var imgFullHeart = UIImage(named: "heart_full.png")
    var imgEmptyHeart = UIImage(named: "heart_empty.png")
    
    override func loadView() {
        super.loadView()

        self.view.backgroundColor = .white
        
        setFrameViews()
        setContentViews()
        setNavItems()
    }
    
    func setFrameViews() {
        
        self.view.addSubview(scvDetailTourSpot)
        scvDetailTourSpot.then {
            $0.isScrollEnabled = true
            $0.translatesAutoresizingMaskIntoConstraints = false
        }.snp.makeConstraints { [unowned self] in
            $0.left.right.equalToSuperview()
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
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
    
    @objc func selectHeart(_ sender: UIBarButtonItem) {

        if(sender.image == imgFullHeart) {
            sender.image = imgEmptyHeart
        } else {
            sender.image = imgFullHeart
        }
    }
    
    func setNavItems(){
        // 배경
        self.navigationController?.navigationBar.barTintColor = .orange
        
        // 제목
        if let title = tourSpotInfo.title {
            self.title = title
        } else {
            self.title = "관광지"
        }
        
        // 오른쪽 - 찜 아이콘
        imgFullHeart = imgFullHeart?.resized(to: CGSize(width: 30, height: 30)).withRenderingMode(.alwaysOriginal)
        imgEmptyHeart = imgEmptyHeart?.resized(to: CGSize(width: 30, height: 30)).withRenderingMode(.alwaysOriginal)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: imgEmptyHeart, style: .plain, target: self, action: #selector(selectHeart(_:)))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.navigationBar.barTintColor = .white
    }
}
