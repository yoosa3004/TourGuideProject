//
//  TGCustomMenuBar.swift
//  TourGuideProject
//
//  Created by hyunndy on 2020/07/10.
//  Copyright © 2020 hyunndy. All rights reserved.
//

/*

 UICollectionView + Indicator을 담고 있는 메뉴바 전체.

 */

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
       setupCustomTabBar()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not benn implemented")
    }
    
    
    // 커스텀메뉴바의 컬렉션뷰
    var customTabBarCollectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .purple
        return collectionView
    }()
    
    
    // 인디케이터뷰?
    var indicatorView = UIView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .black
    }
    
    var indicatorViewLeadingConstraint: NSLayoutConstraint!
    var indicatorViewWidthConstraint: NSLayoutConstraint!
    
    // 콜렉션 뷰 세팅
    func setupCollectionView() {
        customTabBarCollectionView.delegate = self
        customTabBarCollectionView.dataSource = self
        customTabBarCollectionView.showsHorizontalScrollIndicator = false
        customTabBarCollectionView.register(UINib(nibName: TGCustomCell.reusableIdentifier, bundle: nil), forCellWithReuseIdentifier: TGCustomCell.reusableIdentifier)
        
        
        let indexPath = IndexPath(item: 0, section: 0)
        customTabBarCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
    }
    
    // 탭바세팅
    func setupCustomTabBar() {
        
        //--  컬렉션뷰 세팅
        setupCollectionView()
        self.addSubview(customTabBarCollectionView)
        
        customTabBarCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        customTabBarCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        customTabBarCollectionView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        customTabBarCollectionView.heightAnchor.constraint(equalToConstant: 55).isActive = true
        //--
        
        //-- 인디케이터뷰 세팅
        self.addSubview(indicatorView)
        indicatorViewWidthConstraint = indicatorView.widthAnchor.constraint(equalToConstant: self.frame.width/4)
        indicatorViewWidthConstraint.isActive = true
        indicatorView.heightAnchor.constraint(equalToConstant: 5).isActive = true
        
        
        indicatorViewLeadingConstraint = indicatorView.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        indicatorViewLeadingConstraint.isActive = true
        indicatorView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        //--
    }

}

// 익스텐션
extension TGCustomMenuBar: UICollectionViewDelegate, UICollectionViewDataSource {
    
    // 컬렉션뷰의 지정된 위치에 표시할 셀을 요청하는 함수
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // 강제캐스팅하는거 바꾸기!!! -> 굉장히 위험함 guard 구문 사용
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TGCustomCell.reusableIdentifier, for: indexPath) as! TGCustomCell
        return cell
    }
    
    // 지정된 섹션에 표시할 항목의 갯수 - 지역의 갯수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.width / 4 , height: 30)
        
    }

    //  특정 index의 아이템이 선택되었을 때 델리게이트 호출
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.customMenuBar(scrollTo: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? TGCustomCell else { return }
        cell.label.textColor = .lightGray
    }
}

extension TGCustomMenuBar: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
