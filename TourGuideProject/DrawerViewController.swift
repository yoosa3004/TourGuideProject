//
//  DrawerViewController.swift
//  TourGuideProject
//
//  Created by hyunndy on 2020/07/28.
//  Copyright © 2020 hyunndy. All rights reserved.
//

import UIKit
import Then
import SnapKit
import KYDrawerController
import Firebase
import SpringIndicator

class zzimDataInfo {
    
    init(dictionary: [String: Any]) {
        self.contentId = dictionary["contentid"] as? String
        self.addr = dictionary["addr"] as? String
        self.eventDate = dictionary["eventdate"] as? String
        self.image = dictionary["image"] as? String
        self.tel = dictionary["tel"] as? String
        self.thumbNail = dictionary["thumbnail"] as? String
        self.title = dictionary["title"] as? String
    }
    
    init(contentId: String?, image: String?, thumbNail: String?, title: String?, addr: String?, tel: String?, eventDate: String?) {
        self.contentId = contentId
        self.image = image
        self.thumbNail = thumbNail
        self.title = title
        self.addr = addr
        self.tel = tel
        self.eventDate = eventDate
    }
    
    let contentId: String?
    let image: String?
    let thumbNail: String?
    let title: String?
    let addr: String?
    let tel: String?
    let eventDate: String?
    
}

class DrawerViewController: UIViewController {
    
    // Firebase
    let db = Firestore.firestore()
    
    var tbvZZimList = UITableView()
    
    // 찜리스트에 들어갈 데이터
    var zzimListDataInfo = Array(repeating: [zzimDataInfo](), count: 2)
    
    // 인디케이터
    let avZZimListLoading = SpringIndicator(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
    
    override func loadView() {
        super.loadView()
        
        setViews()
    }
    
    func setViews() {
        // 배경
        self.view.backgroundColor = .white
        
        // 네비
        self.title = "찜리스트"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "happiness.png")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(onTapCloseBtn(_:)))
        
        
        // 테이블 뷰
        self.view.addSubview(tbvZZimList)
        tbvZZimList.then {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.register(DrawerTableViewCell.self, forCellReuseIdentifier: DrawerTableViewCell.reusableIdentifier)
            $0.delegate = self
            $0.dataSource = self
        }.snp.makeConstraints {
            $0.top.bottom.left.right.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        // 인디케이터
        self.view.addSubview(avZZimListLoading)
        avZZimListLoading.then {
                let validCenter = CGPoint(x: self.view.center.x, y: self.view.center.y - 100)
                $0.center = validCenter
                $0.lineColor = .red
         }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @objc func onTapCloseBtn(_ sender: UIButton) {
        if let drawerController = parent?.parent as? KYDrawerController {
            drawerController.setDrawerState(.closed, animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        

        getDataFromDB()
    }
    
    
    func getDataFromDB() {
        
        // 로그인 상태에서만
        if let user = Auth.auth().currentUser {
            
            //인디케이터
            self.avZZimListLoading.start()
            
            // 관광지
            var docRef = db.collection("zzimList").document(user.uid).collection("TourSpot")
            docRef.getDocuments { (querySnapshot, err) in
                if let query = querySnapshot {
                    
                    // 1. 기존 데이터 날린다.
                    self.zzimListDataInfo[0].removeAll()
                    
                    // 2. DB에서 읽어온다.
                    for document in query.documents {
                        print(document.data())
                        let tourSpotInfo = zzimDataInfo(dictionary: document.data())
                        self.zzimListDataInfo[0].append(tourSpotInfo)
                    }
                    
                    self.tbvZZimList.reloadData()
                    tgLog("관광지 데이터 로드 완료")
                } else {
                    tgLog("관광지 데이터 없음")
                }
            }
            
            // 행사
            docRef = db.collection("zzimList").document(user.uid).collection("Festival")
            docRef.getDocuments { (querySnapshot, err) in
                if let query = querySnapshot {
                    
                    // 1. 기존 데이터 날린다.
                    self.zzimListDataInfo[1].removeAll()
                    
                    for document in query.documents {
                        print(document.data())
                        let festivalInfo = zzimDataInfo(dictionary: document.data())
                        self.zzimListDataInfo[1].append(festivalInfo)
                    }
                    
                    self.tbvZZimList.reloadData()
                    tgLog("행사 데이터 로드 완료")
                    self.avZZimListLoading.stop()
                } else {
                    tgLog("행사 데이터 없음")
                    self.avZZimListLoading.stop()
                }
            }
        }
    }
}

extension DrawerViewController: UITableViewDelegate, UITableViewDataSource {
    
    // 섹션 2개
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    // 갯수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return zzimListDataInfo[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // 공통 셀
        guard let cclZZim = tableView.dequeueReusableCell(withIdentifier: DrawerTableViewCell.reusableIdentifier, for: indexPath) as? DrawerTableViewCell else {return DrawerTableViewCell()}
        
        
        // 데이터 존재한다면?
        if zzimListDataInfo[indexPath.section].count > 0 {
            
            cclZZim.then {
                let data = zzimListDataInfo[indexPath.section][indexPath.row]
                
                // 제목
                if let title = data.title {
                    $0.lbTitle.text = title
                } else {
                    $0.lbTitle.text = "테스트"
                }
                
                // 주소
                if let addr = data.addr {
                    $0.lbAddr.text = addr
                }
                
                // 이미지
                if let thumbnail = data.thumbNail {
                    $0.ivDrawer.kf.setImage(with: URL(string: thumbnail))
                }
                
                // 행사
                if let eventDate = data.eventDate {
                    $0.lbDate.text = eventDate
                }
            }
        }
        
        return cclZZim
    }
    
    // 행사가 없는 달의 섹션은 보이지 않게함
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    // 헤더 뷰
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 40))
        view.backgroundColor = .systemGray5
    
        
        let ivHeader = UIImageView()
        view.addSubview(ivHeader)
        ivHeader.then {
            if section == 0 {
                $0.image = UIImage(named: "tour_guide.png")
            } else {
                $0.image = UIImage(named: "festival.png")
            }

        }.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.centerY.equalToSuperview()
        }
        
        let lbHeader = UILabel()
        view.addSubview(lbHeader)
        lbHeader.then {
            if section == 0 {
                $0.text = "관광지"
            } else {
                $0.text = "행사"
            }
            
            $0.textAlignment = .center
            $0.textColor = .black
        }.snp.makeConstraints {
            $0.left.equalTo(ivHeader.snp.right).offset(10)
            $0.top.bottom.equalToSuperview()
        }
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.height/5
    }
}
