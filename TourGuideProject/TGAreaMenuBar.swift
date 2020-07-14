//
//  TGAreaMenuBar.swift
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
import SnapKit

// 델리게이트
protocol CustomMenuBarDelegate: class {
    func customMenuBar(scrollTo index: Int)
}

class TGAreaMenuBar: UIView {

    weak var delegate: CustomMenuBarDelegate?
    
    // 초기화
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        
        setupCustomMenuBar()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not benn implemented")
    }
    
    
    // 메뉴바의 개별 항목 (서울/경기/부산 등)
    let menuCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        $0.collectionViewLayout = layout
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .purple
        $0.showsHorizontalScrollIndicator = false
    }
    
    // 인디케이터뷰
    var indicatorView = UIView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .black
    }
    
    var indicatorViewLeadingConstraint: NSLayoutConstraint!
    var indicatorViewWidthConstraint: NSLayoutConstraint!
    
    // 메뉴바 세팅
    func setupCustomMenuBar() {
        
        //메뉴 컬렉션 뷰 세팅
        setupMenu()
        
        //레이아웃 세팅
        bindConstraints()
    }
    
    // 메뉴 항목 세팅
    func setupMenu() {

        menuCollectionView.delegate = self
        menuCollectionView.dataSource = self
        
        menuCollectionView.register(UINib(nibName: TGAreaMenuCell.reusableIdentifier, bundle: nil), forCellWithReuseIdentifier: TGAreaMenuCell.reusableIdentifier)
        menuCollectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: [])
        
        self.addSubview(menuCollectionView)
        self.addSubview(indicatorView)
    }
    
    func bindConstraints(){
        
        // 메뉴 항목
        menuCollectionView.snp.makeConstraints { (make) -> Void in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(55)
        }
        
        // 인디케이터
        indicatorViewWidthConstraint = indicatorView.widthAnchor.constraint(equalToConstant: self.frame.width/4)
        indicatorViewLeadingConstraint = indicatorView.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        indicatorViewLeadingConstraint.isActive = true
        indicatorViewWidthConstraint.isActive = true
        indicatorView.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(5)
            make.bottom.equalToSuperview()
        }
    }
}

// 익스텐션
extension TGAreaMenuBar: UICollectionViewDelegate, UICollectionViewDataSource {
    
    // 컬렉션뷰의 지정된 위치에 표시할 셀을 요청하는 함수
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // 강제캐스팅하는거 바꾸기!!! -> 굉장히 위험함 guard 구문 사용
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TGAreaMenuCell.reusableIdentifier, for: indexPath) as! TGAreaMenuCell
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
        guard let cell = collectionView.cellForItem(at: indexPath) as? TGAreaMenuCell else { return }
        cell.label.textColor = .lightGray
    }
}

extension TGAreaMenuBar: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
