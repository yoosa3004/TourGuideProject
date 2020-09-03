//
//  TGTourSpotViewController.swift
//  TourGuideProject
//
//  Created by hyunndy on 2020/07/09.
//  Copyright © 2020 hyunndy. All rights reserved.
//

import UIKit
import SnapKit
import Then
import ScrollableSegmentedControl
import KYDrawerController
import CRRefresh

class TourSpotListViewController: UIViewController {
    
    let scAreaCategory = UISegmentedControl()
    
    let scvTourSpotList = UIScrollView()
    
    let stvTourSpotList = UIStackView()
    
    override func loadView() {
        super.loadView()
        
        // 뷰 세팅
        setFrameViews()
        setCollectionViewControllerList()
        
        // 드로어 세팅
        self.setDrawer()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scAreaCategory.selectedSegmentIndex = 0
        
        // 첫번째 CollectionView 데이터 로딩 -> 다른 CollectionView는 지역 카테고리에서 선택된 시점에 데이터 로딩
        initDataOnSelectedCollectionView(0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.title = "관광지"
    }
    
    func setFrameViews() {
        
        // 배경
        self.view.backgroundColor = .white
        
        // 세그먼트 컨트롤
        self.view.addSubview(scAreaCategory)
        scAreaCategory.then{ [unowned self] in
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.addTarget(self, action: #selector(changeAreaCategory(_:)), for: .valueChanged)
        }.snp.makeConstraints { [unowned self] in
            $0.left.right.equalToSuperview()
            $0.top.equalTo(self.view.safeAreaLayoutGuide)
            $0.height.equalTo(60)
        }
        
        // 스크롤 뷰
        self.view.addSubview(scvTourSpotList)
        scvTourSpotList.then { [unowned self] in
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.delegate = self
            $0.isPagingEnabled = true
        }.snp.makeConstraints { [unowned self] in
            $0.left.right.equalToSuperview()
            $0.top.equalTo(self.scAreaCategory.snp.bottom)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        // 스택 뷰
        self.scvTourSpotList.addSubview(stvTourSpotList)
        stvTourSpotList.then {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.axis = .horizontal
            $0.distribution = .fillEqually
            $0.alignment = .fill
        }.snp.makeConstraints {
            $0.top.bottom.left.right.height.equalToSuperview()
        }
    }
    
    // MARK: 각 지역 별 CollectionViewController를 child로 추가 -> 기존 delegate로 상세화면으로 이동하는것 개선
    func setCollectionViewControllerList() {
        var idx = 0
        
        for (key, value) in areaCategory {
            scAreaCategory.insertSegment(withTitle: key, at: idx, animated: false)
            
            let vcAreaTourSpot = TourSpotCollectionViewController().then {
                $0.mTourSpot.areaCode = value
                $0.mTourSpot.arrange = "P"
            }
            
            // ChildController로 추가
            self.addChild(vcAreaTourSpot)
            // 스택뷰에 ChildController의 view를 추가
            self.stvTourSpotList.addArrangedSubview(vcAreaTourSpot.view)
            vcAreaTourSpot.view.snp.makeConstraints { [unowned self] in
                $0.height.width.equalTo(self.scvTourSpotList)
            }
            // 이동 완료
            vcAreaTourSpot.didMove(toParent: self)
            
            idx += 1
        }
    }
    
    @objc func changeAreaCategory(_ segmentedControl: UISegmentedControl) {
        
        let screenWidth = UIScreen.main.bounds.maxX
        let idx = CGFloat(segmentedControl.selectedSegmentIndex)
        
        scvTourSpotList.contentOffset.x = screenWidth*idx
        
        initDataOnSelectedCollectionView(segmentedControl.selectedSegmentIndex)
    }
    
    func initDataOnSelectedCollectionView(_ vcIndex: Int) {
        
        if let selectedVC = self.children[vcIndex] as? TourSpotCollectionViewController {
            if selectedVC.isInitData == false {
                selectedVC.isInitData = true
                selectedVC.loadData()
            }
        }
    }
}

extension TourSpotListViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // 스크롤뷰의 사이즈
        let x = scrollView.contentOffset.x
        // 디바이스 화면의 사이즈
        let screenWidth = UIScreen.main.bounds.maxX
        // 스크롤뷰에서 현재 보여지고있는 뷰의 위치
        let selectedIdx = Int(x/screenWidth)
        
        scAreaCategory.selectedSegmentIndex = selectedIdx
        initDataOnSelectedCollectionView(selectedIdx)
    }
}
