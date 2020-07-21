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

class TGFestivalViewController: UIViewController {

    // 테이블뷰
    var tbvFestival = TGFestivalTableView()
    // 데이터로딩 실패
    var lbFailed = UILabel()

    override func loadView() {
        super.loadView()

        self.view.backgroundColor = .white
        setUpView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        TGNetworkingManager().loadFestivalData { [unowned self] (apiData) -> Void in
            if apiData != nil {
                self.tbvFestival.festivalInfos = apiData!
                self.tbvFestival.reloadData()
            } else {
                self.tbvFestival.removeFromSuperview()
                self.view.addSubview(self.lbFailed)
                self.lbFailed.then {
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
            $0.register(UINib(nibName: TGFestivalCell.reusableIdentifier, bundle: nil), forCellReuseIdentifier: TGFestivalCell.reusableIdentifier)
        }.snp.makeConstraints { [unowned self] (make) -> Void in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}

extension TGFestivalViewController: TGFestivalDelegate {
    func selected(_ detailInfo: FestivalData) {
        let detailView = TGFestivalDetailViewController().then {
            $0.dataInfo = detailInfo
        }
        
        self.navigationController?.pushViewController(detailView, animated: true)
    }
}

