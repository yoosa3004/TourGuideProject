//
//  TGFestivalDetailViewController.swift
//  TourGuideProject
//
//  Created by hyunndy on 2020/07/17.
//  Copyright © 2020 hyunndy. All rights reserved.
//

import UIKit
import Then
import SnapKit
import Kingfisher

class FestivalDetailViewController: UIViewController {
    
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
    
    // 찜 아이콘
    var imgFullHeart = UIImage(named: "heart_full.png")?.resized(to: CGSize(width: 30, height: 30)).withRenderingMode(.alwaysOriginal)
    var imgEmptyHeart = UIImage(named: "heart_empty.png")?.resized(to: CGSize(width: 30, height: 30)).withRenderingMode(.alwaysOriginal)
    
    
    override func loadView() {
        super.loadView()
        
        setFrameViews()
        setContentView()
        setNavItem()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.navigationBar.barTintColor = .white
    }
    
    func setFrameViews() {
        // 스크롤뷰
        self.view.addSubview(scvFestival)
        scvFestival.then {
            $0.isScrollEnabled = true
            $0.translatesAutoresizingMaskIntoConstraints = false
        }.snp.makeConstraints { [unowned self] in
            $0.left.right.equalToSuperview()
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
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

    
    @objc func selectHeart(_ sender: UIBarButtonItem) {
        if(sender.image == imgFullHeart) {
            sender.image = imgEmptyHeart
        } else {
            sender.image = imgFullHeart
        }
    }
    
    func setNavItem(){
        
        // 배경
        self.navigationController?.navigationBar.barTintColor = .orange

        if let title = festivalInfo.title {
            self.title = title
        }

        // 오른쪽 - 찜 아이콘
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: imgEmptyHeart, style: .plain, target: self, action: #selector(selectHeart(_:)))
        
    }
}
