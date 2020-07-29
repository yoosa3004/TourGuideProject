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
    
    // 관광지 정보를 담을 컬렉션 뷰
    var listCollectionView = Array<TourSpotCollectionView>()
    
    // 모델
    var mTourSpots = TMTourSpot()
    
    override func loadView() {
        super.loadView()
        
        self.view.backgroundColor = .white
        
        setFrameViews()
        setCollectionViewList()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scAreaCategory.selectedSegmentIndex = 0
        setDrawerView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.title = "관광지"
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
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
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
            $0.top.equalTo(self.scAreaCategory.snp.bottom).offset(10)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
        
        // 스택 뷰
        self.scvTourSpotList.addSubview(stvTourSpotList)
        stvTourSpotList.then {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.axis = .horizontal
            $0.distribution = .fillEqually
            $0.alignment = .fill
        }.snp.makeConstraints { [unowned self] in
            $0.left.right.equalToSuperview()
            $0.top.equalTo(self.scvTourSpotList.snp.top)
            $0.bottom.equalTo(self.scvTourSpotList.snp.bottom)
            $0.height.equalTo(self.scvTourSpotList.snp.height)
        }
    }
    
    func setCollectionViewList() {
        // ** 1) 무의미한 통신 : 화면 별로 따로 구성. 클래스 생성. 그 안에 콜렉션뷰, 에이피아이 관리, 인디케이터 넣기.
        // ** 2) 이 코드를 모듈화.
        var idx = 0
        for (key, value) in areaCategory {
            let cvToutSpot = TourSpotCollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then { [weak self] (cv) -> Void in
                
                cv.backgroundColor = .white
                cv.delegate = cv
                cv.dataSource = cv
                
                // API 요청 변수 세팅
                mTourSpots.areaCode = value
                mTourSpots.arrange = "P"
                
                // 세그먼트 컨트롤
                scAreaCategory.insertSegment(withTitle: key, at: idx, animated: true)
                
                // 레이아웃
                let layout = UICollectionViewFlowLayout()
                layout.scrollDirection = .vertical
                cv.collectionViewLayout = layout
                cv.translatesAutoresizingMaskIntoConstraints = false
                cv.showsHorizontalScrollIndicator = false
                
                // 셀
                cv.register(TourSpotCell.self, forCellWithReuseIdentifier: TourSpotCell.reusableIdentifier)
                cv.tapCellDelegate = self
                
                // 리프레쉬 컨트롤
                cv.cr.addHeadRefresh(animator: NormalFooterAnimator()) { [weak self] in
                    self?.refreshFestivalData(cv)
                }
                
                cv.cr.addFootRefresh(animator: NormalFooterAnimator()) { [weak self] in
                    self?.loadMoreFestivalData(cv)
                }
            }
            
            listCollectionView.append(cvToutSpot)
            
            self.stvTourSpotList.addArrangedSubview(listCollectionView[idx])
            listCollectionView[idx].then { (cv) -> Void in
                // API 요청 후 데이터 받아오기
                mTourSpots.requestAPI { (apiResult) -> Void in
                    if let result = apiResult as? [TourSpotInfo] {
                        cv.listTourSpot = result
                        cv.lbFailed.removeFromSuperview()
                        cv.reloadData()
                    } else {
                        cv.dataLoadFailed()
                    }
                }
            }.snp.makeConstraints { [unowned self] in
                $0.width.equalTo(self.view)
            }
            
            idx += 1
        }
    }
  
    func refreshFestivalData(_ sender: TourSpotCollectionView) {
        sender.cr.endHeaderRefresh()
    }
    
    func loadMoreFestivalData(_ sender: TourSpotCollectionView) {
        sender.cr.endLoadingMore()
    }
    
    @objc func changeAreaCategory(_ segmentedControl: UISegmentedControl) {
        
        let screenWidth = UIScreen.main.bounds.maxX
        let idx = CGFloat(segmentedControl.selectedSegmentIndex)
        
        scvTourSpotList.contentOffset.x = screenWidth*idx
    }
}


extension TourSpotListViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // 스크롤뷰의 사이즈
        let x = scrollView.contentOffset.x
        // 디바이스 화면의 사이즈
        let screenWidth = UIScreen.main.bounds.maxX
        // 스크롤뷰에서 현재 보여지고있는 뷰의 위치
        scAreaCategory.selectedSegmentIndex = Int(x/screenWidth)
    }
}

extension TourSpotListViewController: TourSpotCellDelegate {
    
    // MARK: 셀이 눌린 후 상세화면으로 이동.
    func selected(_ detailInfo: TourSpotInfo) {
        let vDetail = TourSpotDetailViewController().then {
            $0.tourSpotInfo = detailInfo
        }
        
        self.navigationController?.pushViewController(vDetail, animated: true)
    }
}
