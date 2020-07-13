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

class TGTourSpotViewController: UIViewController, CustomMenuBarDelegate {

    // 지역 메뉴바
    var areaMenuBar = TGCustomMenuBar().then {
    
        // view의 크기와 위치를 동적으로 계산하기 위해 이 프로퍼티를 false로 해야함 (auto resizing mask는 view의 크기와 위치를 완전히 고정하므로 추가 constraint를 지정할 수 없기 때문
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // 지역 관광지 뷰
    var areaCollectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 300, height: 300), collectionViewLayout: collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    
    override func loadView() {
        super.loadView()
        
        setUpView()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
     
    
    override func viewWillAppear(_ animated: Bool) {
        
        // MARK: iOS 계층구조에 있다고해서 모든 상위 계층에 접근할 수 있는게 아님. 이 경우 바로 상위계층인 tabBarController에서 title 세팅 필요.
        self.tabBarController?.title = "관광지"
    }
    

    func setUpView() {
        self.view.backgroundColor = UIColor.white
        
        setUpMenuBar()
        setupPageCollectionView()
    }
    
    func setUpMenuBar() {
        
        self.view.addSubview(areaMenuBar)
        
        // 델리게이트 설정
        areaMenuBar.delegate = self
        
        //-- 레이아웃 설정
        areaMenuBar.translatesAutoresizingMaskIntoConstraints = false
        // 시작하는 부분
        areaMenuBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        // 끝나는 부분
        areaMenuBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        // 위
        areaMenuBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        areaMenuBar.heightAnchor.constraint(equalToConstant: 60).isActive = true
        //--
        
        //인디케이터의 width 설정
        areaMenuBar.indicatorViewWidthConstraint.constant = self.view.frame.width / 4
    }
    
    // 메뉴바에 설정된 델리게이트 구현
    func customMenuBar(scrollTo index: Int) {
        self.areaCollectionView.scrollToItem(at: IndexPath(row: index, section: 0), at: .centeredHorizontally, animated: true)
    }
    
    // 지역의 관광지들을 보여주는 CollectionView
    func setupPageCollectionView(){
        
        areaCollectionView.delegate = self
        areaCollectionView.dataSource = self
        areaCollectionView.showsHorizontalScrollIndicator = false
        areaCollectionView.isPagingEnabled = true
        areaCollectionView.register(UINib(nibName: TGCustomPage.reusableIdentifier, bundle: nil), forCellWithReuseIdentifier: TGCustomPage.reusableIdentifier)
        
        self.view.addSubview(areaCollectionView)
        
        //-- 레이아웃 관련
        // 시작
        areaCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        // 끝
        areaCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        // 바닥
        areaCollectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        // 위 - 메뉴바의 밑에 위치
        areaCollectionView.topAnchor.constraint(equalTo: self.areaMenuBar.bottomAnchor).isActive = true
    }
}

//MARK:- UICollectionViewDelegate, UICollectionViewDataSource
extension TGTourSpotViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    // 각 셀 채우기 - 지역 관광지들을 채워야함
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // TGCustomPage를 셀로 이용한다.
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TGCustomPage.reusableIdentifier, for: indexPath) as? TGCustomPage else { return UICollectionViewCell() }
        cell.label.text = "\(indexPath.row + 1)번째 뷰"
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
        areaMenuBar.customTabBarCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
        areaMenuBar.customTabBarCollectionView.scrollToItem(at: indexPath, at: [], animated: true)
    }
}
//MARK:- UICollectionViewDelegateFlowLayout
extension TGTourSpotViewController: UICollectionViewDelegateFlowLayout {
    
    // 각 셀의 사이즈
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout:UICollectionViewLayout , sizeForItemAt indexPath: IndexPath) -> CGSize {
        print("악 \(areaCollectionView.frame.width)")
        print("악 \(areaCollectionView.frame.height)")
        return CGSize(width: areaCollectionView.frame.width, height: areaCollectionView.frame.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
