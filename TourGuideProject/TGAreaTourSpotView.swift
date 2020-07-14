//
//  TGAreaTourSpotView.swift
//  TourGuideProject
//
//  Created by user on 2020/07/12.
//  Copyright © 2020 hyunndy. All rights reserved.
//

import UIKit
import Then

class TGAreaTourSpotView: UICollectionViewCell {

    let containerView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        $0.collectionViewLayout = layout
        $0.backgroundColor = .green
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = .white
        setContainerView()
    }
    
    func setContainerView() {
         self.addSubview(containerView)
        
         containerView.delegate = self
         containerView.dataSource = self
         
         containerView.snp.makeConstraints { (make) -> Void in
             make.leading.equalToSuperview()
             make.trailing.equalToSuperview()
             make.top.equalToSuperview()
             make.height.equalToSuperview()
         }
        
         containerView.register(UINib(nibName: TGTourSpotCell.reusableIdentifier, bundle: nil), forCellWithReuseIdentifier: TGTourSpotCell.reusableIdentifier)
    }
}

extension TGAreaTourSpotView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }

    
    // 셀의 정보 세팅 
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TGTourSpotCell.reusableIdentifier, for: indexPath) as? TGTourSpotCell else { return UICollectionViewCell() }
        
        
       // cell.titleLabel.text = tourInfos[0].title
        
        
        return cell
    }
    
    // 여행장소들이 들어갈 셀의 사이즈
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.width/2, height: self.frame.height/2)

        /*
         
         https://firebasestorage.googleapis.com/v0/b/honggun-blog.appspot.com/o/%E1%84%91%E1%85%B5%E1%84%8F%E1%85%A1%E1%84%8E%E1%85%B2.png?alt=media&token=68c2ffff-81a5-4db9-a67e-b776242cea02
         */


    }
}
