//
//  GeneralDetailViewController.swift
//  TourGuideProject
//
//  Created by hyunndy on 2020/08/04.
//  Copyright © 2020 hyunndy. All rights reserved.
//

import UIKit
import Then
import SnapKit
import Firebase
import YYBottomSheet

class CMDetailViewController: UIViewController {
    
    enum DataType {
        case TourSpot
        case Festival
        case None
        
        func getString() -> String {
            
            switch self {
            case .TourSpot:
                return "TourSpot"
            case .Festival:
                return "Festival"
            default:
                return "None"
            }
        }
    }
    
    // 데이터
    var tourSpotInfo: TourSpotInfo?
    var festivalInfo: FestivalInfo?
    
    // 데이터 타입
    var dataType: DataType = .None
    
    // 상세화면 뷰
    var scvDetail = UIScrollView()
    
    var stvDetail = UIStackView()
    
    var ivDetail = UIImageView()
    
    var lbTitle = UILabel()
    
    var lbAddr = UILabel()
    
    var lbTel = UILabel()
    
    // 찜 아이콘
    var imgFullHeart = UIImage(named: "heart_full")?.withRenderingMode(.alwaysOriginal)
    var imgEmptyHeart = UIImage(named: "heart_empty.png")?.withRenderingMode(.alwaysOriginal)
    
    // Firebase
    let db = Firestore.firestore()
    
    override func loadView() {
        super.loadView()
    
        self.view.backgroundColor = .white
        
        setViews()
        setNavItems()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViewContents()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.navigationBar.barTintColor = .white
    }
    
    func setViewContents() {
        
        switch self.dataType {
        case .TourSpot:
            if let tourSpotInfo = self.tourSpotInfo {
                self.setContents(image: tourSpotInfo.image, title: tourSpotInfo.title, addr1: tourSpotInfo.addr1, addr2: tourSpotInfo.addr2, tel: tourSpotInfo.tel)
                self.checkIsHeartSelected(tourSpotInfo.contentid)
            }
        case .Festival:
            if let festivalInfo = self.festivalInfo {
                self.setContents(image: festivalInfo.image, title: festivalInfo.title, addr1: festivalInfo.addr1, addr2: festivalInfo.addr2, tel: festivalInfo.tel)
                self.checkIsHeartSelected(festivalInfo.contentid)
            }
        default:
            showToast(message: "데이터가 로드되지 않았습니다.")
        }
    }
    
    func checkIsHeartSelected(_ contentId : Int?) {
        if let user = Auth.auth().currentUser {
            if let contentId = contentId {
                let docRef = db.collection("zzimList").document(user.uid).collection(self.dataType.getString()).document(String(contentId))

                docRef.getDocument { (document, err) in
                    if let document = document, document.exists {
                        self.navigationItem.rightBarButtonItem?.image = self.imgFullHeart
                    }
                }
            }
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
    
    func setViews() {
        
        // 스크롤뷰
        self.view.addSubview(scvDetail)
        scvDetail.then {
            $0.isScrollEnabled = true
            $0.translatesAutoresizingMaskIntoConstraints = false
        }.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        
        // 스택뷰
        self.scvDetail.addSubview(stvDetail)
        stvDetail.then {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.axis = .horizontal
            $0.distribution = .fillEqually
            $0.alignment = .fill
        }.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.left.right.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        // 상세 이미지
        self.stvDetail.addSubview(ivDetail)
        ivDetail.then {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.contentMode = .scaleAspectFit
        }.snp.makeConstraints {
            $0.top.equalToSuperview().offset(15)
            $0.width.equalToSuperview().multipliedBy(0.9)
            $0.height.equalTo(ivDetail.snp.width).multipliedBy(0.8)
            $0.centerX.equalToSuperview()
        }
        
        // 상세 제목
        self.stvDetail.addSubview(lbTitle)
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
        self.stvDetail.addSubview(lbAddr)
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
            $0.height.equalTo(25)
        }
        
        // 전화번호
        self.stvDetail.addSubview(lbTel)
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
    
    func setNavItems() {
        
        // 배경
        self.navigationController?.navigationBar.barTintColor = .orange
        
        // 네비 제목
        switch self.dataType {
        case .TourSpot:
            self.title = tourSpotInfo?.title ?? "관광지"
        case .Festival:
            self.title = festivalInfo?.title ?? "행사"
        default:
            self.title = "상세화면"
        }
        
        // 오른쪽 - 찜 아이콘
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: self.imgEmptyHeart, style: .plain, target: self, action: #selector(self.selectHeart(_:)))
    }
    
    @objc func selectHeart(_ sender: UIBarButtonItem) {
        
        if(sender.image == imgFullHeart) {
            self.removeFromzzimList() {
                sender.image = self.imgEmptyHeart
            }
        } else {
            self.insertTozzimList() {
                sender.image = self.imgFullHeart
            }
        }
    }
    
    func insertTozzimList(updateIcon: @escaping () -> Void) {
        
        // 유저 검사
        if let user = Auth.auth().currentUser {
            
            switch self.dataType {
            case .TourSpot:
                if let tourSpotInfo = self.tourSpotInfo, let contentId = tourSpotInfo.contentid {
                    let likedTourSpot = TourSpotInfo(title: tourSpotInfo.title, addr1: tourSpotInfo.addr1, addr2: tourSpotInfo.addr2, image: tourSpotInfo.image, thumbnail: tourSpotInfo.thumbnail, tel: tourSpotInfo.tel)
                    
                    db.collection("zzimList").document(user.uid).collection(self.dataType.getString()).document(String(contentId)).setData(["title": likedTourSpot.title ?? "제목이 제공되지 않습니다.", "addr": likedTourSpot.addr1 ?? "주소가 제공되지 않습니다.", "image": likedTourSpot.image ?? "No Image", "thumbnail": likedTourSpot.thumbnail ?? "No Image", "tel": likedTourSpot.tel ?? "전화번호가 제공되지 않습니다.", "eventdate": ""]) { err in
                        
                        if err == nil {
                            self.showToast(message: "찜리스트에 담았습니다.")
                            updateIcon()
                        } else {
                            self.showToast(message: "찜리스트에 담기를 실패했습니다.")
                            tgLog(err)
                        }
                    }
                }
            case .Festival:
                if let festivalInfo = self.festivalInfo, let contentId = festivalInfo.contentid {
                    
                    let likedFestivalInfo = FestivalInfo(title: festivalInfo.title, addr1: festivalInfo.addr1, addr2: festivalInfo.addr2, image: festivalInfo.image, thumbnail: festivalInfo.thumbnail, tel: festivalInfo.tel, eventDate: festivalInfo.convertedEventDate)
                    
                    db.collection("zzimList").document(user.uid).collection(self.dataType.getString()).document(String(contentId)).setData(["title": likedFestivalInfo.title ?? "제목이 제공되지 않습니다.", "addr": likedFestivalInfo.addr1 ?? "주소가 제공되지 않습니다.", "image": likedFestivalInfo.image ?? "No Image", "thumbnail": likedFestivalInfo.thumbnail ?? "No Image", "tel": likedFestivalInfo.tel ?? "전화번호가 제공되지 않습니다.", "eventdate": likedFestivalInfo.convertedEventDate ?? "행사 일정이 제공되지 않습니다."]) { err in
                        
                        if err == nil {
                            self.showToast(message: "찜리스트에 담았습니다.")
                            updateIcon()
                        } else {
                            self.showToast(message: "찜리스트에 담기를 실패했습니다.")
                            tgLog(err)
                        }
                    }
                }
            default:
                showToast(message: "데이터가 로드되지 않았습니다.")
            }
        } else {
            showToast(message: "찜 기능은 로그인 후 사용할 수 있습니다.")
        }
    }
    
    func removeFromzzimList(updateIcon: @escaping () -> Void) {
        
        // 유저 검사
        if let user = Auth.auth().currentUser {
            
            var docRef: DocumentReference? = nil
            
            switch self.dataType {
            case .TourSpot:
                if let contentId = tourSpotInfo?.contentid {
                    docRef = db.collection("zzimList").document(user.uid).collection(self.dataType.getString()).document(String(contentId))
                }
            case .Festival:
                if let contentId = festivalInfo?.contentid {
                    docRef = db.collection("zzimList").document(user.uid).collection(self.dataType.getString()).document(String(contentId))
                }
            default:
                showToast(message: "데이터가 로드되지 않았습니다.")
            }
            
            if let docRef = docRef {
                docRef.getDocument { (doc, err) in
                    if let doc = doc, doc.exists {
                        docRef.delete()
                        self.showToast(message: "찜리스트에서 제거됐습니다.")
                        updateIcon()
                    }
                }
            }
        }
    }
    
    func showToast(message: String) {
        let option: [YYBottomSheet.SimpleToastOptions:Any] = [
            .showDuration: 2.0,
            .backgroundColor: UIColor.black,
            .beginningAlpha: 0.8,
            .messageFont: UIFont.italicSystemFont(ofSize: 15),
            .messageColor: UIColor.white
        ]
        
        let simpleToast = YYBottomSheet.init(simpleToastMessage: message, options: option)
        
        simpleToast.show()
    }
}
