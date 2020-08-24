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
import ObjectMapper
import FirebaseAuth
import SpringIndicator
import YYBottomSheet

class DrawerViewController: UIViewController {

    // MARK: Firebase DB에 올라가는 찜리스트 데이터 클래스
    class ZZimListInfo: Mappable {

        var contentId: Int?
        var image: String?
        var thumbNail: String?
        var title: String?
        var addr: String?
        var tel: String?
        var eventstartdate: Int?
        var eventenddate: Int?
        
        // 관광지/행사 데이터타입
        var dataType: DataType = .None
        
        required init?(map: Map) {}
        
        func mapping(map: Map) {
            contentId <- map["contentid"]
            addr <- map["addr"]
            eventstartdate <- map["eventstartdate"]
            eventenddate <- map["eventenddate"]
            image <- map["image"]
            tel <- map["tel"]
            thumbNail <- map["thumbnail"]
            title <- map["title"]
        }
    }
    
    struct Section {
        var name: String
        var items: [ZZimListInfo]
        var collapsed: Bool = true
        
        init(name: String, items: [ZZimListInfo], collapsed: Bool = false) {
            self.name = name
            self.items = items
            self.collapsed = collapsed
        }
    }
    
    var sections = [Section]()
    
    // Firebase
    let db = Firestore.firestore()
    
    // 인디케이터
    let avZZimListLoading = SpringIndicator(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
    
    var tbvZZimList = UITableView()
    
    override func loadView() {
        super.loadView()
        
        sections.append(Section(name: "관광지", items: [ZZimListInfo]()))
        sections.append(Section(name: "행사", items: [ZZimListInfo]()))
        
        setViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getDataFromDB()
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

    
    @objc func onTapCloseBtn(_ sender: UIButton) {
        if let drawerController = parent?.parent as? KYDrawerController {
            drawerController.setDrawerState(.closed, animated: true)
        }
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
                        if let tourSpotInfo = ZZimListInfo(JSON: document.data()) {
                            tourSpotInfo.dataType = .TourSpot
                            self.sections[0].items.append(tourSpotInfo)
                        }
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
                    
                    // 2. DB에서 읽어온다.
                    for document in query.documents {
                        if let festivalInfo = ZZimListInfo(JSON: document.data()) {
                            festivalInfo.dataType = .Festival
                            self.sections[1].items.append(festivalInfo)
                        }
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
            String("찜리스트는 로그인 상태일 때 이용할 수 있습니다.").showToast()
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
                    if title.contains("[") && data.dataType == .Festival {
                        $0.lbTitle.attributedText = NSAttributedString().splitByBracket(title)
                    } else {
                        $0.lbTitle.text = title
                    }
                }
                
                // 주소
                if let addr = data.addr {
                    $0.lbAddr.text = addr
                }
                
                // 이미지
                if let thumbnail = data.thumbNail {
                    $0.ivDrawer.kf.setImage(with: URL(string: thumbnail))
                }
                
                // 날짜
                if data.dataType == .TourSpot {
                    $0.lbDate.text = ""
                } else {
                    if let startDate = data.eventstartdate {
                        if let endDate = data.eventenddate {
                            if startDate != 0 && endDate != 0 {
                                let convertedEventDate = String(startDate.changeDateFormat()) + " ~ " + String(endDate.changeDateFormat())
                                $0.lbDate.text = convertedEventDate
                            }
                        }
                    }
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
        
        // 헤더 이미지 세팅
        if sections[section].collapsed {
            header.ivArrow.image = UIImage(named: "down_arrow.png")?.withRenderingMode(.alwaysOriginal)
        } else {
            header.ivArrow.image = UIImage(named: "up_arrow.png")?.withRenderingMode(.alwaysOriginal)
        }
        
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
            
            let data = self.sections[indexPath.section].items[indexPath.row]
            
            switch data.dataType {
            case .TourSpot:
                $0.tourSpotInfo = TourSpotInfo(title: data.title, addr1: data.addr, addr2: "", image: data.image, thumbnail: data.thumbNail, tel: data.tel)
                $0.tourSpotInfo?.contentid = data.contentId
                $0.dataType = .TourSpot
            case .Festival:
                $0.festivalInfo = FestivalInfo(title: data.title, addr1: data.addr, addr2: "", image: data.image, thumbnail: data.thumbNail, tel: data.tel, eventstartdate: data.eventstartdate, eventenddate: data.eventenddate)
                $0.festivalInfo?.contentid = data.contentId
                $0.dataType = .Festival
            default:
                return
            }
            
            $0.isInZZimList = true
        }
        
        self.navigationController?.pushViewController(vcDetail, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let delete = UIContextualAction(style: .normal, title: "삭제") { [unowned self] _, _, completionHandler in
            
            if let user = Auth.auth().currentUser {
                if let contentId = self.sections[indexPath.section].items[indexPath.row].contentId {
                    let docRef = self.db.collection("zzimList").document(user.uid).collection(self.sections[indexPath.section].items[indexPath.row].dataType.rawValue).document(String(contentId))
                    
                    docRef.getDocument { (doc, err) in
                        if let doc = doc, doc.exists {
                            docRef.delete()
                            String("찜리스트에서 제거됐습니다.").showToast()
                            self.sections[indexPath.section].items.remove(at: indexPath.row)
                            self.tbvZZimList.deleteRows(at: [indexPath], with: .automatic)
                        }
                        
                        if err != nil {
                            String("찜리스트 제거에 실패했습니다.").showToast()
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
        
        // 섹션에 데이터가 없다면 접히지 않도록 하기
        if sections[section].items.isEmpty { return }
        
        let collapsed = !sections[section].collapsed
        
        sections[section].collapsed = collapsed
        
        self.tbvZZimList.reloadSections(IndexSet.init(integer: section), with: .automatic)
    }
}
