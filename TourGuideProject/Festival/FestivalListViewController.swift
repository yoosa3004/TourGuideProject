//
//  TGFestivalViewController.swift
//  TourGuideProject
//
//  Created by hyunndy on 2020/07/09.
//  Copyright © 2020 hyunndy. All rights reserved.
//

import UIKit
import SnapKit
import Then

class FestivalListViewController: UIViewController {

    // 모델
    let mFestivals = TMFestivals()
    
    // 테이블뷰
    var tbvFestival = FestivalTableView()
    
    // 리프레쉬 컨트롤
    let rcrFestical = UIRefreshControl()
    
    // 데이터 로딩 실패 시 띄울 라벨
    var lbDataLoadFailed = UILabel()

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
        self.view.addSubview(self.tbvFestival)
        tbvFestival.then { [unowned self] in
            $0.delegate = $0
            $0.dataSource = $0
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.tapCellDelegate = self
            $0.register(FestivalCell.self, forCellReuseIdentifier: FestivalCell.reusableIdentifier)
        }.snp.makeConstraints { [unowned self] in
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.left.right.bottom.equalToSuperview()
        }
    
        // 테이블 뷰 리프레쉬 컨트롤
        rcrFestical.addTarget(self, action: #selector(refreshFestivalData(_:)), for: .valueChanged)
        if #available(iOS 10.0, *) {
            tbvFestival.refreshControl = rcrFestical
        } else {
            tbvFestival.addSubview(rcrFestical)
        }
    }
    
    @objc func refreshFestivalData(_ sender: UIRefreshControl) {
        sender.endRefreshing()
    }

    func loadData() {
        mFestivals.eventStartDate = 20200101
        mFestivals.arrange = "P"
        
        mFestivals.requestAPI { [unowned self] (apiResult) -> Void in
            if let result = apiResult as? [FestivalInfo] {
                // API로부터 데이터 받은 후 날짜순으로 정렬 후 월 단위로 쪼갬
                self.sortByStartDate(result) { (sortedInfos) -> Void in
                    for idx in sortedInfos.indices {
                        self.tbvFestival.listFestivalInfo[idx] = sortedInfos[idx]
                    }
                    
                    self.tbvFestival.reloadData()
                }
            } else {
                self.loadDataFailed()
            }
        }
    }
    
    func loadDataFailed() {
        self.tbvFestival.removeFromSuperview()
        self.view.addSubview(self.lbDataLoadFailed)
        self.lbDataLoadFailed.then {
            $0.text = "데이터 로드 실패"
        }.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    // MARK: API로부터 받은 데이터를 날짜순으로 정렬 후 월 단위로 쪼개어 테이블 뷰 데이터에 넣어줄 행사 정보 배열 생성 (1월 행사, 2월 행사, 3월 행사, ...)
    func sortByStartDate(_ targetArr: Array<FestivalInfo>, update: @escaping(_ a: [[FestivalInfo]]) -> Void) {
        
        var sortedArr = Array(repeating: [FestivalInfo](), count: 12)
        var tempArr = targetArr
        
        // 날짜순 정렬
        tempArr.sort { (left: FestivalInfo, right:FestivalInfo) -> Bool in
            
            return left.eventstartdate! < right.eventstartdate!
        }
        
        // 월 단위로 쪼개어 적재
        for idx in 0 ... 8 {
            
            let test = "2020" + "0" + String(idx+1)
            
            let arr = tempArr.filter {
                $0.eventstartdate! >= Int(test+"01")! && $0.eventstartdate! <= Int(test+"31")!
            }
            
            sortedArr[idx].append(contentsOf: arr)
        }
        
        for idx in 9 ... 11 {
            
            let test = "2020" + String(idx+1)
            
            let arr = tempArr.filter {
                $0.eventstartdate! >= Int(test+"01")! && $0.eventstartdate! <= Int(test+"31")!
            }
            
            sortedArr[idx].append(contentsOf: arr)
        }
        
        // 클로저에서 테이블 뷰 reload
        update(sortedArr)
    }
}

extension FestivalListViewController: FestivalDelegate {
    func selected(_ detailInfo: FestivalInfo) {
        let detailView = FestivalDetailViewController().then {
            $0.festivalInfo = detailInfo
        }
        
        self.navigationController?.pushViewController(detailView, animated: true)
    }
}

