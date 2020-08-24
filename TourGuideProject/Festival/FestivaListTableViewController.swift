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
import Alamofire
import SpringIndicator

class FestivaListTableViewController: UIViewController {
    
    // 행사를 월 별로 관리 + toggle 이벤트를 위한 Section 구조체.
    struct MonthSection {
        var items = [FestivalInfo]()
        var collapsed: Bool = false
    }
    
    // 데이터
    var sections = Array(repeating: MonthSection(), count: 12)
    
    // API 로딩 완료 후 최종 데이터만 sections에 넣어주기 위한 임시 배열
    var tempArr = Array(repeating: [FestivalInfo](), count: 12)
    
    // API 로드 용 변수
    let mFestivals = TMFestivals()
    
    // 리프레쉬 컨트롤
    let rcrFestical = UIRefreshControl()
    
    // 인디케이터
    let avFestivalLoading = SpringIndicator(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
    
    // 테이블뷰
    var tbvFestivalInfo = UITableView()
    
    let lbDataLoadFailed = UILabel()
    
    override func loadView() {
        super.loadView()
        
        setViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.title = "행사"
    }
    
    func setViews() {
        
        // 배경
        self.view.backgroundColor = .white
        
        // 테이블 뷰
        self.view.addSubview(tbvFestivalInfo)
        tbvFestivalInfo.then { [unowned self] in
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.delegate = self
            $0.dataSource = self
            
            // 셀 등록
            $0.register(FestivalCell.self, forCellReuseIdentifier: FestivalCell.reusableIdentifier)
            
            // 리프레시 컨트롤
            $0.refreshControl  = rcrFestical
            $0.refreshControl?.addTarget(self, action: #selector(refreshFestivalData(_:)), for: .valueChanged)
        }.snp.makeConstraints {
            $0.top.bottom.left.right.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        // 인디케이터
        self.view.addSubview(self.avFestivalLoading)
        self.view.bringSubviewToFront(self.avFestivalLoading)
        avFestivalLoading.then { [unowned self] in
            $0.center = CGPoint(x: self.view.center.x, y: self.view.center.y)
            $0.lineColor = .red
        }
    }
    
    @objc func refreshFestivalData(_ sender: Any) {
        
        // 데이터 로드 실패 라벨 삭제
        self.lbDataLoadFailed.removeFromSuperview()
        
        // 데이터 삭제
        self.tempArr = Array(repeating: [FestivalInfo](), count: 12)
        
        // 데이터 로드 재개
        self.loadData()
        
        self.tbvFestivalInfo.refreshControl?.endRefreshing()
    }
    
    func loadData() {
        
        // 인디케이터 실행
        self.avFestivalLoading.start()
        
        /*
        // 시간초과 검사를 위해 함수 추가
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            
            print("시간초과")
            Alamofire.SessionManager.default.session.getTasksWithCompletionHandler { data, upload, download in
                data.forEach { $0.cancel() }
                upload.forEach { $0.cancel() }
                download.forEach { $0.cancel() }
            }
            
            self.checkDataIsEmpty()
            return
        }
         */
        
        // 현재 날짜부터 조회
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        let currentDate = formatter.string(from: Date())
        mFestivals.eventStartDate = Int(currentDate)
    
        var finishedRequestNum = 0
        for pageNo in 1...mFestivals.maxPageNo {
            mFestivals.pageNo = pageNo
            
            mFestivals.requestAPI { [unowned self] in
                finishedRequestNum += 1
                
                if let sortedInfo = $0 as? [[FestivalInfo]] {
                    for idx in sortedInfo.indices {
                        self.tempArr[idx].append(contentsOf: sortedInfo[idx])
                    }
                    
                    tgLog("\(pageNo)번째 API 로드 완료")
                }
             
                // 최대치만큼 API 호출 + 월 별로 분리 + 정렬까지 한 후에 tableView에 쓰일 데이터에 세팅해줌.
                if finishedRequestNum == self.mFestivals.maxPageNo {
                    print("\(finishedRequestNum)개 로드 완료!!")
                    
                    self.checkDataIsEmpty()
                }
            }
        }
    }
    
    // 데이터 로드 실패인지 데이터 업데이트할건지 검사하는 함수
    func checkDataIsEmpty() {
        var isDataLoadFailed = true
         for idx in self.tempArr.indices {
             if self.tempArr[idx].count > 0 {
                 isDataLoadFailed = false
                 break
             }
         }
         
         if isDataLoadFailed {
             self.loadDataFailed()
         } else {
             self.updateData()
         }
    }
    
    // API로부터 받아온 데이터를 실제 테이블뷰에 세팅
    func updateData() {
        
        self.avFestivalLoading.stop()
        
        for idx in self.tempArr.indices {
            self.tempArr[idx].sort { (left: FestivalInfo, right:FestivalInfo) -> Bool in
                return left.eventstartdate ?? 0 <= right.eventstartdate ?? 0
            }
            
            self.sections[idx].items = self.tempArr[idx]
        }
        
        self.tbvFestivalInfo.separatorStyle = .singleLine
        self.tbvFestivalInfo.reloadData()
    }
    
    // 데이터 로드 실패 시 처리
    func loadDataFailed() {
        
        // 인디케이터 stop
        self.avFestivalLoading.stop()
        
        // 테이블뷰 줄 없애기
        self.tbvFestivalInfo.separatorStyle = .none
        self.sections = Array(repeating: MonthSection(), count: 12)
        self.tbvFestivalInfo.reloadData()
        
        // 데이터로드 실패 라벨
        lbDataLoadFailed.then { [unowned self] in
            $0.frame = self.tbvFestivalInfo.bounds
            $0.text = "데이터 로드 실패"
            $0.textAlignment = .center
        }
        
        // 라벨 띄우기
        self.tbvFestivalInfo.backgroundView = UIView(frame: self.tbvFestivalInfo.bounds)
        self.tbvFestivalInfo.backgroundView?.addSubview(lbDataLoadFailed)
    }
}

extension FestivaListTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].collapsed ? 1 : sections[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if sections[indexPath.section].collapsed {
            return UITableViewCell()
        }
        
        let cclFestivalInfo = tableView.dequeueReusableCell(withIdentifier: FestivalCell.reusableIdentifier, for: indexPath) as? FestivalCell ?? FestivalCell(style: .default, reuseIdentifier: FestivalCell.reusableIdentifier)
        
        // 셀 세팅
        if sections[indexPath.section].items.count > 0 {
            cclFestivalInfo.then {
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
                    }
                }
                
                // 행사 이미지
                if let thumbnail = data.thumbnail {
                    $0.ivFestival.kf.setImage(with: URL(string: thumbnail), options: nil)
                }
            }
        }
        
        return cclFestivalInfo
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if sections[indexPath.section].collapsed {
            return 0
        } else {
            return self.view.frame.height/5
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        // 셀 클릭 시 상세화면 VC 세팅
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
        
        if sections[section].collapsed {
            header.ivArrow.image = UIImage(named: "down_arrow.png")?.withRenderingMode(.alwaysOriginal)
        } else {
            header.ivArrow.image = UIImage(named: "up_arrow.png")?.withRenderingMode(.alwaysOriginal)
        }
        
        header.section = section
        header.delegate = self
        
        return header
    }
}

extension FestivaListTableViewController: FestivalTableViewHeaderDelegate {
    
    // 헤더 클릭 시 Section 별 Toggle 적용
    func toggleSection(_ header: FestivalTableViewHeader, section: Int) {
        
        if sections[section].items.isEmpty { return }
        
        let collapsed = !sections[section].collapsed
        
        sections[section].collapsed = collapsed
        
        UIView.performWithoutAnimation {
            self.tbvFestivalInfo.reloadSections(IndexSet.init(integer: section), with: .none)
        }
        
        //self.tbvFestivalInfo.reloadSections(IndexSet.init(integer: section), with: .automatic)
    }
}
