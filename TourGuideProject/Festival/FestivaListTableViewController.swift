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

class FestivaListTableViewController: UITableViewController {
    
    // 모델
    let mFestivals = TMFestivals()
    
    // 리프레쉬 컨트롤
    let rcrFestical = UIRefreshControl()
    
    // 데이터
    var listFestivalInfo = Array(repeating: [FestivalInfo](), count: 12)
    
    // 인디케이터
    let avFestivalLoading = SpringIndicator(frame: CGRect(x: 0, y: 0, width: 60, height: 60))

    override func loadView() {
        super.loadView()
        
        // 인디케이터
         self.view.addSubview(avFestivalLoading)
        avFestivalLoading.then {
             // MARK: center가 왜 내가 생각하는 center와 다른지 확인 요망....
             let validCenter = CGPoint(x: self.view.center.x, y: self.view.center.y - 100)
             $0.center = validCenter
             $0.lineColor = .red
        }.start()
        
        setViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.title = "행사"
    }
    
    func loadData() {
        mFestivals.eventStartDate = 20200101
        mFestivals.arrange = "P"
        
        mFestivals.requestAPI { [unowned self] in
            if let sortedInfo = $0 as? [[FestivalInfo]] {
                for idx in sortedInfo.indices {
                    self.listFestivalInfo[idx] = sortedInfo[idx]
                }
                self.tableView.reloadData()
            } else {
                self.loadDataFailed()
            }
            
            self.avFestivalLoading.stop()
        }
    }
    
    func loadDataFailed() {
        let lbDataLoadFailed = UILabel(frame: self.tableView.bounds)
        lbDataLoadFailed.text = "데이터 로드 실패"
        lbDataLoadFailed.textAlignment = .center
        self.tableView.backgroundView = UIView(frame: tableView.bounds)
        self.tableView.backgroundView?.addSubview(lbDataLoadFailed)
    }

    func setViews() {
        self.view.backgroundColor = .white
        
        self.tableView.then { [unowned self] in
            
            $0.translatesAutoresizingMaskIntoConstraints = false
            
            $0.register(FestivalCell.self, forCellReuseIdentifier: FestivalCell.reusableIdentifier)
            
            // 리프레시 컨트롤
            $0.refreshControl  = rcrFestical
            $0.refreshControl?.addTarget(self, action: #selector(refreshFestivalData(_:)), for: .valueChanged)
            $0.cr.addFootRefresh(animator: NormalFooterAnimator()) { [weak self] in
                self?.loadMoreFestivalData()
            }
        }
    }
    
    @objc func refreshFestivalData(_ sender: Any) {
        self.tableView.refreshControl?.endRefreshing()
    }
    
    func loadMoreFestivalData() {
        self.tableView.cr.noticeNoMoreData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if listFestivalInfo.count > 0 {
            return listFestivalInfo[section].count
        }else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cclFestivalInfo = tableView.dequeueReusableCell(withIdentifier: FestivalCell.reusableIdentifier, for: indexPath) as? FestivalCell else {return FestivalCell()}
        // 셀 세팅
        if listFestivalInfo[indexPath.section].count > 0 {
            return cclFestivalInfo.then {
                let data = listFestivalInfo[indexPath.section][indexPath.row]
                
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
            return cclFestivalInfo
        }
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.height/5
    }
    
    // 셀 클릭시 델리게이트 호출
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vDetail = GeneralDetailViewController().then {
            $0.festivalInfo = listFestivalInfo[indexPath.section][indexPath.row]
        }
        
        self.navigationController?.pushViewController(vDetail, animated: true)
    }
    
    // 섹션 갯수
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 12
    }
    
    
    // 행사가 없는 달의 섹션은 보이지 않게함
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if listFestivalInfo.count == 0 { return 0 }
        
        if listFestivalInfo[section].count == 0 {
            return CGFloat.leastNormalMagnitude
        } else {
            return 40
        }
    }
    
    // 헤더 뷰
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 40))
        view.backgroundColor = .systemGray5
        
        let ivHeader = UIImageView()
        view.addSubview(ivHeader)
        ivHeader.then {
            $0.image = UIImage(named: "happiness.png")
        }.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.centerY.equalToSuperview()
        }
        
        let lbHeader = UILabel()
        view.addSubview(lbHeader)
        lbHeader.then {
            $0.text = "\(section+1)월"
            $0.textAlignment = .center
            $0.textColor = .black
        }.snp.makeConstraints {
            $0.left.equalTo(ivHeader.snp.right).offset(10)
            $0.top.bottom.equalToSuperview()
        }
        
        return view
    }
}
