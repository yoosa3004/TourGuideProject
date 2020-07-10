//
//  TGCustomMenuBar.swift
//  TourGuideProject
//
//  Created by hyunndy on 2020/07/10.
//  Copyright © 2020 hyunndy. All rights reserved.
//

import UIKit
import Then

// 델리게이트
protocol CustomMenuBarDelegate: class {
    func customMenuBar(scrollTo index: Int)
}


class TGCustomMenuBar: UIView {

    weak var delegate: CustomMenuBarDelegate?
    
    // 초기화
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        //setupCustomBar()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not benn implemented")
    }
    
    // 메뉴바 안을 구성하고 있는 CollectionViewd의 Flowlayout
    var customTabBarCollectionView: UICollectionView =  {
        
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: CGRect(x:0, y:0, width:0, height:0), collectionViewLayout: collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    // 선택된 셀을 나타내는 인디케이터
    var indicatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        return view
    }()
    
    var indicatorViewLeadingConstraint: NSLayoutConstraint!
    var indicatorViewWidthConstraint: NSLayoutConstraint!
    
    // 콜렉션 뷰 세팅
    func setupCollectionView() {
        //customTabBarCollectionView.delegate = self
        //customTabBarCollectionView.dataSource = self
        customTabBarCollectionView.showsHorizontalScrollIndicator = false
        customTabBarCollectionView.register(UINib(nibName: TGCustomCell.reusableIdentifier, bundle: nil), forCellWithReuseIdentifier: TGCustomCell.reusableIdentifier)
        customTabBarCollectionView.isScrollEnabled = false
        
        let indexPath = IndexPath(item: 0, section: 0)
        customTabBarCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
    }
    
    // 탭바세팅

    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
