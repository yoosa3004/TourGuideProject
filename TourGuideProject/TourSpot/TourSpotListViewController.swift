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
            let cvToutSpot = TourSpotCollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then { [weak self] in
                
                $0.backgroundColor = .white
                $0.delegate = $0
                $0.dataSource = $0
                
                // API 요청 변수 세팅
                mTourSpots.areaCode = value
                mTourSpots.arrange = "P"
                
                // 세그먼트 컨트롤
                scAreaCategory.insertSegment(withTitle: key, at: idx, animated: true)
                
                // 레이아웃
                let layout = UICollectionViewFlowLayout()
                layout.scrollDirection = .vertical
                $0.collectionViewLayout = layout
                $0.translatesAutoresizingMaskIntoConstraints = false
                $0.showsHorizontalScrollIndicator = false
                
                // 셀
                $0.register(TourSpotCell.self, forCellWithReuseIdentifier: TourSpotCell.reusableIdentifier)
                $0.tapCellDelegate = self
            }
            
            // 리프레쉬 컨트롤
            let rcrTourSpot = UIRefreshControl()
            rcrTourSpot.addTarget(self, action: #selector(refreshTourSpotData(_:)), for: .valueChanged)
            if #available(iOS 10.0, *) {
                cvToutSpot.refreshControl = rcrTourSpot
            } else {
                cvToutSpot.addSubview(rcrTourSpot)
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
  
    @objc func refreshTourSpotData(_ sender: UIRefreshControl) {
        sender.endRefreshing()
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
