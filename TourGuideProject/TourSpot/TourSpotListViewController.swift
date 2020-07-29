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
        
        self.view.backgroundColor = .white
        
        setFrameViews()
        setCollectionViewControllerList()
        setDrawerView()
        
        self.scAreaCategory.selectedSegmentIndex = 0
        initDataOnSelectedCollectionView(0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.title = "관광지"
    }
    
    // MARK: 실제 데이터가 보여질 CollectionView를 제외한 나머지 Frame이 되는 View 세팅
    func setFrameViews() {
        
        // 세그먼트 컨트롤
        self.view.addSubview(scAreaCategory)
        scAreaCategory.then{
            $0.selectedSegmentIndex = 0
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.addTarget(self, action: #selector(changeAreaCategory(_:)), for: .valueChanged)
        }.snp.makeConstraints { [unowned self] in
            $0.left.right.equalToSuperview()
            $0.top.equalTo(self.view.safeAreaLayoutGuide)
            $0.height.equalTo(60)
        }
        
        // 스크롤 뷰
        self.view.addSubview(scvTourSpotList)
        scvTourSpotList.then {
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
    
    func setCollectionViewControllerList() {
        var idx = 0
        for (key, value) in areaCategory {
            
            scAreaCategory.insertSegment(withTitle: key, at: idx, animated: true)
            
            let vcTourSpot = TourSpotCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout().then {
                $0.scrollDirection = .vertical
            }).then {
                $0.mTourSpot.areaCode = value
                $0.mTourSpot.arrange = "P"
                $0.view.translatesAutoresizingMaskIntoConstraints = false
            }
            
            self.addChild(vcTourSpot)
            self.stvTourSpotList.addArrangedSubview(vcTourSpot.view)
            vcTourSpot.view.snp.makeConstraints {
                $0.height.width.equalTo(self.scvTourSpotList)
                $0.top.bottom.equalToSuperview()
            }
            vcTourSpot.didMove(toParent: self)
            
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
            if selectedVC.listTourSpot.isEmpty {
                selectedVC.loadData()
            }
        }
    }
    
    // 드로어 메뉴
    func setDrawerView()  {
        self.tabBarController?.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "drawer.png")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(tabDrawerIcon(_:)) )
    }
    
    @objc func tabDrawerIcon(_ sender: UIBarButtonItem) {
        if let drawerController = self.navigationController?.parent as? KYDrawerController {
            drawerController.setDrawerState(.opened, animated: true)
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
