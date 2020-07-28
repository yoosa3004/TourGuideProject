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
        
        mFestivals.requestAPI { [unowned self] in
            if let sortedInfo = $0 as? [[FestivalInfo]] {
                for idx in sortedInfo.indices {
                    self.tbvFestival.listFestivalInfo[idx] = sortedInfo[idx]
                }
                self.tbvFestival.reloadData()
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
}

extension FestivalListViewController: FestivalDelegate {
    func selected(_ detailInfo: FestivalInfo) {
        let detailView = FestivalDetailViewController().then {
            $0.festivalInfo = detailInfo
        }
        
        self.navigationController?.pushViewController(detailView, animated: true)
    }
}

