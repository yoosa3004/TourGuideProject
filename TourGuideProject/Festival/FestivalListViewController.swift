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
    
    // 데이터 로딩 실패 시 띄울 라벨
    var lbDataLoadFailed = UILabel()

    override func loadView() {
        super.loadView()

        self.view.backgroundColor = .white
        setUpView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mFestivals.eventStartDate = 20200101
        mFestivals.arrange = "P"
        
        mFestivals.requestAPI { [unowned self] (apiData) -> Void in
            if apiData != nil {
                let final = apiData as! [FestivalData]
                self.mFestivals.sortByDate(final) { (finalData) -> Void in
                    for idx in finalData.indices {
                        self.tbvFestival.festivalInfo[idx] = finalData[idx]
                    }
                }
                
                self.tbvFestival.reloadData()
                
            } else {
                self.tbvFestival.removeFromSuperview()
                self.view.addSubview(self.lbDataLoadFailed)
                self.lbDataLoadFailed.then {
                    $0.text = "데이터 로드 실패"
                }.snp.makeConstraints {
                    $0.center.equalToSuperview()
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // MARK: iOS 계층구조에 있다고해서 모든 상위 계층에 접근할 수 있는게 아님. 이 경우 바로 상위계층인 tabBarController에서 title 세팅 필요.
        self.tabBarController?.title = "행사"
    }
    

    private func setUpView() {
        self.view.addSubview(self.tbvFestival)
        tbvFestival.then { [unowned self] in
            $0.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
            $0.delegate = $0
            $0.dataSource = $0
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.tapCellDelegate = self
            $0.register(UINib(nibName: FestivalCell.reusableIdentifier, bundle: nil), forCellReuseIdentifier: FestivalCell.reusableIdentifier)
        }.snp.makeConstraints { [unowned self] (make) -> Void in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}

extension FestivalListViewController: FestivalDelegate {
    func selected(_ detailInfo: FestivalData) {
        let detailView = FestivalDetailViewController().then {
            $0.dataInfo.append(detailInfo)
        }
        
        self.navigationController?.pushViewController(detailView, animated: true)
    }
}
