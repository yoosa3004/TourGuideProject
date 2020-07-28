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
    
    // 데이터
    var tourSpotInfo = TourSpotInfo()
    
    // 상세화면 뷰
    var vDetail = TourSpotDetailView()
    
    // 찜 아이콘
    var imgFullHeart = UIImage(named: "heart_full")
    var imgEmptyHeart = UIImage(named: "heart_empty.png")
    
    override func loadView() {
        super.loadView()

        self.view.backgroundColor = .white
        
         self.view.addSubview(vDetail)
        vDetail.then { [unowned self] in
            $0.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
            $0.tourSpotInfo = self.tourSpotInfo
        }.setViews()
        
        setNavItems()
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
