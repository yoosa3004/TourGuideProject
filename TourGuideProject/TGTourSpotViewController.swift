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

    var pageCollectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), collectionViewLayout: collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    // 메뉴바
    var customMenubar = TGCustomMenuBar()
    
    
    let testLabel = UILabel().then {
        $0.text = "관광지정보"
        $0.textColor = .black
        $0.textAlignment = .center
        $0.bounds = CGRect(x: 0, y: 0, width: 100, height: 100)
        $0.backgroundColor = .purple
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
    
        self.view.backgroundColor = UIColor.white
        
        setUpView()
    }
     
    
    override func viewWillAppear(_ animated: Bool) {
        
        // MARK: iOS 계층구조에 있다고해서 모든 상위 계층에 접근할 수 있는게 아님. 이 경우 바로 상위계층인 tabBarController에서 title 세팅 필요.
        self.tabBarController?.title = "관광지"
    }
    

    func setUpView() {
        
        setupCustomTabBar()
        setupPageCollectionView()
    }
    
    func setupCustomTabBar() {
        self.view.addSubview(customMenubar)
        customMenubar.delegate = self
        customMenubar.translatesAutoresizingMaskIntoConstraints = false
        customMenubar.indicatorViewWidthConstraint.constant = self.view.frame.width / 4
        customMenubar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        customMenubar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        customMenubar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        customMenubar.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    func customMenuBar(scrollTo index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        self.pageCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    func setupPageCollectionView(){
        pageCollectionView.delegate = self
        pageCollectionView.dataSource = self
        pageCollectionView.backgroundColor = .gray
        pageCollectionView.showsHorizontalScrollIndicator = false
        pageCollectionView.isPagingEnabled = true
        pageCollectionView.register(UINib(nibName: TGCustomPage.reusableIdentifier, bundle: nil), forCellWithReuseIdentifier: TGCustomPage.reusableIdentifier)
        self.view.addSubview(pageCollectionView)
        pageCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        pageCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        pageCollectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        pageCollectionView.topAnchor.constraint(equalTo: self.customMenubar.bottomAnchor).isActive = true
    }
}

//MARK:- UICollectionViewDelegate, UICollectionViewDataSource
extension TGTourSpotViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TGCustomPage.reusableIdentifier, for: indexPath) as! TGCustomPage
        cell.label.text = "\(indexPath.row + 1)번째 뷰"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        customMenubar.indicatorViewLeadingConstraint.constant = scrollView.contentOffset.x / 4
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let itemAt = Int(targetContentOffset.pointee.x / self.view.frame.width)
        let indexPath = IndexPath(item: itemAt, section: 0)
        customMenubar.customTabBarCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
    }
}
//MARK:- UICollectionViewDelegateFlowLayout
extension TGTourSpotViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: pageCollectionView.frame.width, height: pageCollectionView.frame.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
