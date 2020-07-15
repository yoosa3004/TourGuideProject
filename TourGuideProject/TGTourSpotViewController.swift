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

protocol TourSpotVCDelegate: class {
    func updateData()
}

class TGTourSpotViewController: UIViewController, CustomMenuBarDelegate {
    
    var delegate: TourSpotVCDelegate?
    
    // 지역 메뉴바
    var areaMenuBar = TGAreaMenuBar().then {
        // view의 크기와 위치를 동적으로 계산하기 위해 이 프로퍼티를 false로 해야함 (auto resizing mask는 view의 크기와 위치를 완전히 고정하므로 추가 constraint를 지정할 수 없기 때문
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // 지역 관광지 그리드뷰를 나타내기 위한 container View
    var areaCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        $0.backgroundColor = .white
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.showsHorizontalScrollIndicator = false
        $0.isPagingEnabled = true
        $0.collectionViewLayout = layout
    }
    
    
    override func loadView() {
        super.loadView()
    
        setUpView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        TGNetworkingManager().loadData {
            print("데이터로드를 완료했습니다.")
            self.delegate?.updateData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // MARK: iOS 계층구조에 있다고해서 모든 상위 계층에 접근할 수 있는게 아님. 이 경우 바로 상위계층인 tabBarController에서 title 세팅 필요.
        self.tabBarController?.title = "관광지"
    }
    

    func setUpView() {
        self.view.backgroundColor = UIColor.white
        
        setUpMenuBar()
        setupAreaCollectionView()
        
        bindConstraint()
    }
    
    func setUpMenuBar() {
        
        self.view.addSubview(areaMenuBar)
        
        // 델리게이트 설정
        areaMenuBar.delegate = self
    }
    
    // 지역의 관광지들을 보여주는 CollectionView
    func setupAreaCollectionView(){
        
        self.view.addSubview(areaCollectionView)
        
        areaCollectionView.delegate = self
        areaCollectionView.dataSource = self
        areaCollectionView.register(UINib(nibName: TGAreaTourSpotView.reusableIdentifier, bundle: nil), forCellWithReuseIdentifier: TGAreaTourSpotView.reusableIdentifier)
    }
    
    func bindConstraint() {
        
        // 메뉴바
        areaMenuBar.snp.makeConstraints { (make) -> Void in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.height.equalTo(60)
        }
        
        // 메뉴바의 인디케이터
        areaMenuBar.indicatorViewWidthConstraint.constant = self.view.frame.width / 4
        
        // 지역 관광지 컬렉션 뷰
        areaCollectionView.snp.makeConstraints { (make) -> Void in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            make.top.equalTo(self.areaMenuBar.snp.bottom)
        }
    }
    
    // 메뉴바에 설정된 델리게이트 구현
    func customMenuBar(scrollTo index: Int) {
        self.areaCollectionView.scrollToItem(at: IndexPath(row: index, section: 0), at: .centeredHorizontally, animated: true)
    }
}

//MARK:- UICollectionViewDelegate, UICollectionViewDataSource
extension TGTourSpotViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    // 각 셀 채우기 - 지역 관광지들을 채워야함
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // TGAreaTourSpotView를 셀로 이용한다.
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TGAreaTourSpotView.reusableIdentifier, for: indexPath) as? TGAreaTourSpotView else { return TGAreaTourSpotView() }
        
        // 델리게이트 위임자를 각 cell로 설정한다.
        self.delegate = cell
        
        return cell
    }
    
    // 각 섹션의 아이템 갯수 - 지역 관광지 갯수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    // 페이지에다가 대고 scroll 했을 때 메뉴바의 인디케이터 시작점 변화시키기
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        areaMenuBar.indicatorViewLeadingConstraint.constant = scrollView.contentOffset.x / 4
    }
    
    // PageCollectionView에서 옆으로 드래깅했을 때 areaMenuBar의 항목에 맞게 이동시키기
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let itemAt = Int(targetContentOffset.pointee.x / self.view.frame.width)
        let indexPath = IndexPath(item: itemAt, section: 0)
        areaMenuBar.menuCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
        areaMenuBar.menuCollectionView.scrollToItem(at: indexPath, at: [], animated: true)
    }
}
//MARK:- UICollectionViewDelegateFlowLayout
extension TGTourSpotViewController: UICollectionViewDelegateFlowLayout {
    
    // 각 셀의 사이즈
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout:UICollectionViewLayout , sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        //셀 즉 TGAreaTourSpotView의 사이즈
        return CGSize(width: areaCollectionView.frame.width, height: areaCollectionView.frame.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
