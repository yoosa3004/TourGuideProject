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
import FirebaseFirestore
import FirebaseAuth
import SpringIndicator
import YYBottomSheet

class ZZimDataInfo {
    
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
    
    // 관광지/행사 데이터타입
    var dataType: String = ""
}

struct Section {
    var name: String
    var items: [ZZimDataInfo]
    var collapsed: Bool
    
    init(name: String, items: [ZZimDataInfo], collapsed: Bool = false) {
        self.name = name
        self.items = items
        self.collapsed = collapsed
    }
}

class DrawerViewController: UIViewController {
    
    var sections = [Section]()
    
    // Firebase
    let db = Firestore.firestore()
    
    var tbvZZimList = UITableView()
    
    // 인디케이터
    let avZZimListLoading = SpringIndicator(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
    
    override func loadView() {
        super.loadView()
        
        sections.append(Section(name: "관광지", items: [ZZimDataInfo]()))
        sections.append(Section(name: "행사", items: [ZZimDataInfo]()))
        
        setViews()
    }
    
    func setViews() {
        // 배경
        self.view.backgroundColor = .white
        
        // 네비
        self.title = "찜리스트"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "close.png")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(onTapCloseBtn(_:)))
        
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
                    self.sections[0].items.removeAll()
                    
                    // 2. DB에서 읽어온다.
                    for document in query.documents {
                        print(document.data())
                        let tourSpotInfo = ZZimDataInfo(dictionary: document.data())
                        tourSpotInfo.dataType = "TourSpot"
                        self.sections[0].items.append(tourSpotInfo)
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
                    self.sections[1].items.removeAll()
                    
                    for document in query.documents {
                        print(document.data())
                        let festivalInfo = ZZimDataInfo(dictionary: document.data())
                        festivalInfo.dataType = "Festival"
                        self.sections[1].items.append(festivalInfo)
                    }
                    
                    self.tbvZZimList.reloadData()
                    tgLog("행사 데이터 로드 완료")
                    self.avZZimListLoading.stop()
                } else {
                    tgLog("행사 데이터 없음")
                    self.avZZimListLoading.stop()
                }
            }
        } else {
            showToast(message: "찜리스트는 로그인 상태일 때 이용할 수 있습니다.")
            self.sections[0].items.removeAll()
            self.sections[1].items.removeAll()
            self.tbvZZimList.reloadData()
        }
    }
}

extension DrawerViewController: UITableViewDelegate, UITableViewDataSource {
    
    // 섹션 2개
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    // 갯수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].collapsed ? 1 : sections[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if sections[indexPath.section].collapsed { return UITableViewCell() }
        
        // 공통 셀
        guard let cclZZim = tableView.dequeueReusableCell(withIdentifier: DrawerTableViewCell.reusableIdentifier, for: indexPath) as? DrawerTableViewCell else {return DrawerTableViewCell()}
        
        
        // 데이터 존재한다면?
        if sections[indexPath.section].items.count > 0 {
            
            cclZZim.then {
                let data = self.sections[indexPath.section].items[indexPath.row]
                
                // 제목
                if let title = data.title {
                    $0.lbTitle.text = title
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
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1.0
    }
    
    // 헤더 뷰
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as? DrawerTableViewHeader ?? DrawerTableViewHeader(reuseIdentifier: "header")
        
        header.ivHeader.then {
            if section == 0 {
                $0.image = UIImage(named: "tour_guide.png")
            } else {
                $0.image = UIImage(named: "festival.png")
            }
        }
        header.lbTitle.text = sections[section].name
        
        header.section = section
        header.delegate = self
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if sections[indexPath.section].collapsed {
            return 0
        } else {
            return self.view.frame.height/6
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vcDetail = CMDetailViewController().then {
            $0.zzimListInfo = self.sections[indexPath.section].items[indexPath.row]
            $0.dataType = .ZZimList
        }
        
        self.navigationController?.pushViewController(vcDetail, animated: true)
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
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let delete = UIContextualAction(style: .normal, title: "삭제") { [unowned self] _, _, completionHandler in
            
            if let user = Auth.auth().currentUser {
                if let contentId = self.sections[indexPath.section].items[indexPath.row].contentId {
                    let docRef = self.db.collection("zzimList").document(user.uid).collection(self.sections[indexPath.section].items[indexPath.row].dataType).document(contentId)
                    
                    docRef.getDocument { (doc, err) in
                        if let doc = doc, doc.exists {
                            docRef.delete()
                            self.showToast(message: "찜리스트에서 제거됐습니다.")
                            self.sections[indexPath.section].items.remove(at: indexPath.row) // 섹션 리무브
                            self.tbvZZimList.deleteRows(at: [indexPath], with: .automatic)
                        }
                        
                        if err != nil {
                            self.showToast(message: "찜리스트 제거에 실패했습니다.")
                        }
                    }
                }
            }
            
            completionHandler(true)
        }
        
        delete.image = UIImage(named: "close.png")
        delete.backgroundColor = .systemRed
        let configuration = UISwipeActionsConfiguration(actions: [delete])
        return configuration
    }
}

extension DrawerViewController: DrawerTableViewHeaderDelegate {
    
    func toggleSelection(_ header: DrawerTableViewHeader, section: Int) {
        let collapsed = !sections[section].collapsed
        
        sections[section].collapsed = collapsed
        
        self.tbvZZimList.beginUpdates()
        self.tbvZZimList.reloadSections(IndexSet.init(integer: section), with: .automatic)
        self.tbvZZimList.endUpdates()
    }
}
