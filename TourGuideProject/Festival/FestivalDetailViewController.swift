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
    
    // 상세화면 view
    var vDetail = FestivalDetailView()
    
    // 상세화면에 나타낼 데이터
    var festivalInfo = FestivalInfo()
    
    // 찜 아이콘
    var imgFullHeart = UIImage(named: "heart_full.png")?.resized(to: CGSize(width: 30, height: 30)).withRenderingMode(.alwaysOriginal)
    var imgEmptyHeart = UIImage(named: "heart_empty.png")?.resized(to: CGSize(width: 30, height: 30)).withRenderingMode(.alwaysOriginal)
    
    
    override func loadView() {
        super.loadView()
        
        self.view.addSubview(vDetail)
        vDetail.then { [unowned self] in
            $0.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
            $0.festivalInfo = self.festivalInfo
        }.setViews()
        
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
