//
//  FestivaListTableViewController.swift
//  TourGuideProject
//
//  Created by hyunndy on 2020/07/29.
//  Copyright © 2020 hyunndy. All rights reserved.
//

import UIKit
import Then
import SnapKit
import CRRefresh
import SpringIndicator

class FestivaListTableViewController: UIViewController {
    
    // 데이터
    struct Section {
        var items = [FestivalInfo]()
        var collapsed: Bool = false
    }
    
    var sections = Array(repeating: Section(), count: 12)
    
    // 모델
    let mFestivals = TMFestivals()
    var loadedPageNo: Int = 1
    
    // 리프레쉬 컨트롤
    let rcrFestical = UIRefreshControl()
    
    // 인디케이터
    let avFestivalLoading = SpringIndicator(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
    
    // 테이블뷰
    var tbvFestivalInfo = UITableView()

    override func loadView() {
        super.loadView()
        
        setViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.title = "행사"
    }
    
    func loadDataFailed() {
        let lbDataLoadFailed = UILabel(frame: self.tbvFestivalInfo.bounds)
        lbDataLoadFailed.text = "데이터 로드 실패"
        lbDataLoadFailed.textAlignment = .center
        self.tbvFestivalInfo.backgroundView = UIView(frame: self.tbvFestivalInfo.bounds)
        self.tbvFestivalInfo.backgroundView?.addSubview(lbDataLoadFailed)
    }

    func setViews() {
        
        // 배경
        self.view.backgroundColor = .white
        
        // 테이블 뷰
        self.view.addSubview(tbvFestivalInfo)
        tbvFestivalInfo.then {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.register(FestivalCell.self, forCellReuseIdentifier: FestivalCell.reusableIdentifier)
            $0.delegate = self
            $0.dataSource = self
            
            // 리프레시 컨트롤
            $0.refreshControl  = rcrFestical
            $0.refreshControl?.addTarget(self, action: #selector(refreshFestivalData(_:)), for: .valueChanged)
        }.snp.makeConstraints {
            $0.top.bottom.left.right.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        // 인디케이터
        self.view.addSubview(self.avFestivalLoading)
        self.view.bringSubviewToFront(self.avFestivalLoading)
        avFestivalLoading.then {
            let validCenter = CGPoint(x: self.view.center.x, y: self.view.center.y)
            $0.center = validCenter
            $0.lineColor = .red
        }.start()
        
    }
    
    @objc func refreshFestivalData(_ sender: Any) {
        self.tbvFestivalInfo.reloadData()
        self.tbvFestivalInfo.refreshControl?.endRefreshing()
    }
    
    func loadData() {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        let currentDate = formatter.string(from: Date())
        
        mFestivals.eventStartDate = Int(currentDate)
        mFestivals.arrange = "P"
        
        for pageNo in 1...10 {
            mFestivals.pageNo = pageNo
            
            mFestivals.requestAPI { [unowned self] in
                if let sortedInfo = $0 as? [[FestivalInfo]] {
                    for idx in sortedInfo.indices {
                        self.sections[idx].items.append(contentsOf: sortedInfo[idx])
                        self.tbvFestivalInfo.reloadData()
                    }
                } else {
                    self.loadDataFailed()
                    self.avFestivalLoading.stop()
                    return
                }
                
                if pageNo == 10 {
                    
                    for idx in self.sections.indices {
                        self.sections[idx].items.sort { (left: FestivalInfo, right:FestivalInfo) -> Bool in
                            return left.eventstartdate ?? 0 < right.eventstartdate ?? 0
                        }
                    }
                    
                    self.tbvFestivalInfo.reloadData()
                    self.avFestivalLoading.stop()
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
    }
}

extension FestivaListTableViewController: UITableViewDelegate, UITableViewDataSource, FestivalTableViewHeaderDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].collapsed ? 1 : sections[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if sections[indexPath.section].collapsed {
            return UITableViewCell()
        }
        
        let cclFestivalInfo = tableView.dequeueReusableCell(withIdentifier: FestivalCell.reusableIdentifier, for: indexPath) as? FestivalCell ?? FestivalCell(style: .default, reuseIdentifier: FestivalCell.reusableIdentifier)
        
        // 셀 세팅
        if sections[indexPath.section].items.count > 0 && !sections[indexPath.section].collapsed {
            return cclFestivalInfo.then {
                let data = sections[indexPath.section].items[indexPath.row]
                
                // 행사 제목
                if let title = data.title {
                    if title.contains("[") {
                        $0.lbTitle.attributedText = NSAttributedString().splitByBracket(title)
                    } else {
                        $0.lbTitle.text = title
                    }
                }
                
                // 행사 주소
                if let str = data.addr1 {
                    $0.lbAddr.text = str
                    if let str2 = data.addr2 {
                        $0.lbAddr.text = str+str2
                    }
                }
                
                // 행사 날짜
                if let startDate = data.eventstartdate {
                    if let endDate = data.eventenddate {
                        let convertedEventDate = String(startDate.changeDateFormat()) + " ~ " + String(endDate.changeDateFormat())
                        $0.lbDate.text = convertedEventDate
                        data.convertedEventDate = convertedEventDate
                    }
                }
                
                // 행사 이미지
                if let thumbnail = data.thumbnail {
                    $0.ivFestival.kf.setImage(with: URL(string: thumbnail), options: nil)
                }
            }
        } else {
            return UITableViewCell()
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if sections[indexPath.section].collapsed {
            return 0
        } else {
            return self.view.frame.height/5
        }
    }
    
    // 셀 클릭시 델리게이트 호출
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vDetail = CMDetailViewController().then {
            $0.festivalInfo = sections[indexPath.section].items[indexPath.row]
            $0.dataType = .Festival
        }
        
        self.navigationController?.pushViewController(vDetail, animated: true)
    }
    
    // 섹션 갯수
    func numberOfSections(in tableView: UITableView) -> Int {
        return 12
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1.0
    }
    
    // 행사가 없는 달의 섹션은 보이지 않게함
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if sections[section].items.count == 0 {
            return CGFloat.leastNormalMagnitude
        } else {
            return 40
        }
    }
    
    // 헤더 뷰
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as? FestivalTableViewHeader ?? FestivalTableViewHeader(reuseIdentifier: "header")
    
        header.ivHeader.image = UIImage(named: "happiness.png")
        header.lbTitle.text = "\(section+1)월"
        header.section = section
        header.delegate = self
        
        return header
    }
    
    func toggleSection(_ header: FestivalTableViewHeader, section: Int) {
        let collapsed = !sections[section].collapsed
        
        sections[section].collapsed = collapsed

        UIView.performWithoutAnimation {
            self.tbvFestivalInfo.reloadSections(IndexSet.init(integer: section), with: .none)
        }
        
//        self.tbvFestivalInfo.reloadSections(IndexSet.init(integer: section), with: .automatic)
    }
}
