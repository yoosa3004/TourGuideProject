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

class TGFestivalDetailViewController: UIViewController {

    // 데이터
    var dataInfo = FestivalData()
    // 이미지뷰
    var ivDetail = UIImageView()
    // 제목
    var lbTitle = UILabel()
    // 주소(addr1 + addr2)
    var lbAddr = UILabel()
    // 전화번호
    var lbTel = UILabel()
    // 찜아이콘
    var imgFullHeart = UIImage(named: "heart_full.png")
    var imgEmptyHeart = UIImage(named: "heart_empty.png")
    
    func setUpViews() {
        
        // 이미지뷰
        self.view.addSubview(ivDetail)
        ivDetail.then {
            $0.frame = CGRect(x: 0, y: 0, width: self.view.frame.width/2, height: self.view.frame.height/2)
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.contentMode = .scaleAspectFit
            $0.image = imgFullHeart
        }.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(50)
            make.centerX.equalToSuperview()
        }
        
        let processor = DownsamplingImageProcessor(size: ivDetail.bounds.size)
        ivDetail.kf.setImage(with: URL(string: dataInfo.image!), options: [.processor(processor)])
        
        // 행사 이름
        self.view.addSubview(lbTitle)
        lbTitle.then {
            $0.text = dataInfo.title
            $0.textAlignment = .center
            $0.numberOfLines = 0
            $0.lineBreakMode = .byWordWrapping
            $0.font = UIFont.systemFont(ofSize: 20, weight: .bold)
            $0.textColor = .black
            $0.translatesAutoresizingMaskIntoConstraints = false
        }.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.ivDetail.snp.bottom).offset(25)
            make.centerX.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
        
        // 관광지 주소 뷰
        self.view.addSubview(lbAddr)
        lbAddr.then {
            if let str = dataInfo.addr1 {
                $0.text = str
                if let str2 = dataInfo.addr2 {
                    $0.text = str+str2
                }
            }
            $0.textAlignment = .center
            $0.numberOfLines = 0
            $0.lineBreakMode = .byWordWrapping
            $0.font = UIFont.systemFont(ofSize: 20, weight: .bold)
            $0.textColor = .black
            $0.translatesAutoresizingMaskIntoConstraints = false
        }.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalTo(self.lbTitle.snp.bottom).offset(25)
            make.centerX.equalToSuperview()
        }
        
        // 관광지 전화번호 뷰
        self.view.addSubview(lbTel)
        lbTel.then {
            $0.text = dataInfo.tel
            
            $0.textAlignment = .center
            $0.numberOfLines = 0
            $0.lineBreakMode = .byWordWrapping
            $0.font = UIFont.systemFont(ofSize: 20, weight: .bold)
            $0.textColor = .black
            $0.translatesAutoresizingMaskIntoConstraints = false
        }.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalTo(self.lbAddr.snp.bottom).offset(25)
            make.centerX.equalToSuperview()
        }
    }
    
    override func loadView() {
        super.loadView()
        

        setUpViews()
        setNavItem()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white

    }
    
    @objc func selectHeart(_ sender: UIBarButtonItem) {
        
        // 꽉찬하트
        if(sender.image == imgFullHeart) {
            sender.image = imgEmptyHeart
        } else {
            sender.image = imgFullHeart
        }
    }
    
    func setNavItem(){
        
        // tabbar가 있는 형태가 아닌 이 컨트롤러만 있으니까 바로 navigationItem으로 접근
        // 제목
        self.navigationItem.title = dataInfo.title
        
        // backbuttonItem에 관광지로 표기 -> 원래는 클릭한 cell의 title이 표기되었음
        self.navigationController?.navigationBar.topItem?.title = "행사"
        
        // 오른쪽 - 찜 아이콘
        imgFullHeart = imgFullHeart?.resized(to: CGSize(width: 30, height: 30))
        imgEmptyHeart = imgEmptyHeart?.resized(to: CGSize(width: 30, height: 30))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: imgEmptyHeart, style: .plain, target: self, action: #selector(selectHeart(_:)))
    }
    

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

}

