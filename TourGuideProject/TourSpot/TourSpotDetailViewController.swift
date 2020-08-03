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
import FirebaseAuth
import FirebaseCore
import Firebase

class TourSpotDetailViewController: UIViewController {
    
    // Firebase
    let db = Firestore.firestore()
    var ref: DocumentReference? = nil
    
    // 데이터
    var tourSpotInfo = TourSpotInfo()
    
    // 상세화면 뷰
    var vDetail = GeneralDetailView()
    
    // 찜 아이콘
    var imgFullHeart = UIImage(named: "heart_full")?.withRenderingMode(.alwaysOriginal)
    var imgEmptyHeart = UIImage(named: "heart_empty.png")?.withRenderingMode(.alwaysOriginal)
    
    override func loadView() {
        super.loadView()
        
        self.view.backgroundColor = .white
        
        self.view.addSubview(vDetail)
        vDetail.then { [unowned self] in
            $0.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
            $0.setViews()
            $0.checkContentDataType(self.tourSpotInfo)
        }
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: self.imgEmptyHeart, style: .plain, target: self, action: #selector(self.selectHeart(_:)))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavItems()
    }
    
    @objc func selectHeart(_ sender: UIBarButtonItem) {
        
        if(sender.image == imgFullHeart) {
            sender.image = imgEmptyHeart
            self.deleteData()
            
        } else {
            sender.image = imgFullHeart
            self.insertData()
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
        if let user = Auth.auth().currentUser {
            
            let docRef = db.collection("zzimList").document(user.uid).collection("TourSpot").document(tourSpotInfo.title!)
            // 유저가 있을 땐 찜리스트에 있던애인가 검사
            
            docRef.getDocument { (document, err) in
                if let document = document, document.exists {
                    self.navigationItem.rightBarButtonItem?.image = self.imgFullHeart
                } else {
                    self.navigationItem.rightBarButtonItem?.image = self.imgEmptyHeart
                }
            }
        } else {
            self.navigationItem.rightBarButtonItem?.image = self.imgEmptyHeart
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.navigationBar.barTintColor = .white
    }
    
    func insertData() {
        // 유저 검사
        if let user = Auth.auth().currentUser {
            
            // DTO로 만들기
            let likedTourSpot = TourSpotInfo(title: tourSpotInfo.title, addr1: tourSpotInfo.addr1, addr2: tourSpotInfo.addr2, image: tourSpotInfo.image, thumbnail: tourSpotInfo.thumbnail, tel: tourSpotInfo.tel)
            
            if let title = likedTourSpot.title {
                db.collection("zzimList").document(user.uid).collection("TourSpot").document(title).setData(["Title": title, "Addr": likedTourSpot.addr1 ?? "주소가 제공되지 않습니다", "Image": likedTourSpot.image ?? "No Image", "Thumbnail": likedTourSpot.thumbnail ?? "No Image", "Tel": likedTourSpot.tel ?? "전화번호가 제공되지 않습니다."])
            }
        } else {
            print("유저가 없다")
            return
        }
    }
    
    func deleteData() {
        
        // 유저 검사
        if let user = Auth.auth().currentUser {
            let docRef = db.collection("zzimList").document(user.uid).collection("TourSpot").document(tourSpotInfo.title!)
            // 유저가 있을 땐 찜리스트에 있던애인가 검사
            
            docRef.getDocument { (document, err) in
                if let document = document, document.exists {
                    docRef.delete()
                    print("데이터 삭제 완료")
                } else {
                    print("데이터가 없습니다")
                }
            }
        } else {
            print("유저가 없습니다")
        }
    }
}
