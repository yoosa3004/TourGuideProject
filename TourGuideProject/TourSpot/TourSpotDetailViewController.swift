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
    //@test
    var ref: DocumentReference? = nil
    
    // 데이터
    var tourSpotInfo = TourSpotInfo()
    
    // 상세화면 뷰
    var vDetail = GeneralDetailView()
    
    // 찜 아이콘
    var imgFullHeart = UIImage(named: "heart_full")
    var imgEmptyHeart = UIImage(named: "heart_empty.png")
    
    override func loadView() {
        super.loadView()

        self.view.backgroundColor = .white
        
         self.view.addSubview(vDetail)
         vDetail.then { [unowned self] in
             $0.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
             $0.setViews()
             $0.setTypeOfData(self.tourSpotInfo)
         }
        
        setNavItems()
    }
    
    @objc func selectHeart(_ sender: UIBarButtonItem) {

        if(sender.image == imgFullHeart) {
            sender.image = imgEmptyHeart
            self.delete()
            
        } else {
            sender.image = imgFullHeart
            self.insert()
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
    
    func insert() {

        // 유저 검사
        if let user = Auth.auth().currentUser {
            
            // DTO로 만들기
            let likedTourSpot = TourSpotInfo(title: vDetail.lbTitle.text)
            
            self.ref?.collection("TourSpot").document(user.uid).setData(["Title": likedTourSpot.title ?? "관광지"])
            
    
        } else {
            return
        }
    }
    
    func delete() {
        
    }
    
    /*
    //{{ @HYEONJIY 선택된 사진을 store 버킷에 넣고, 성공한다면 contentDTO에 넣어서 Firebase DB에 넣어주는 함수. 제일 중요함
    private fun contentUpload(){

            val newNote = Note(
                note_title.text.toString(),
                posterUrl?.toString(),
                note_contents.text.toString(),
                note_ratingBar.rating,
                System.currentTimeMillis(),
                FirebaseAuth.getInstance().currentUser?.uid!!
            )

     
         //        Auth.auth().currentUser?.uid
     
            firestore?.collection("MovieNote")?.document(newNote.uid)?.collection("reviews")?.document(newNote.timestamp.toString())?.set(newNote)
            finish()
    }
    */
}
