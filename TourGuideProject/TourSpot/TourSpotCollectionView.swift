//
//  TGTourSpotCollectionView2.swift
//  TourGuideProject
//
//  Created by hyunndy on 2020/07/16.
//  Copyright © 2020 hyunndy. All rights reserved.
//

import UIKit
import Then
import Kingfisher
import SnapKit

protocol TourSpotCellDelegate: class {
    func selected(_ detailInfo: TourSpotInfo)
}

class TourSpotCollectionView: UICollectionView {
    
    // 델리게이트
    weak var tapCellDelegate: TourSpotCellDelegate?
    
    // 모델
    var mTourSpots = TMTourSpot()
    
    // 데이터
    var listTourSpot = Array<TourSpotInfo>()
    
    // 데이터 로드 실패 시 띄울 라벨
    let lbFailed = UILabel()
    
    func loadData() {
        mTourSpots.requestAPI { [unowned self] in
            if let result = $0 as? [TourSpotInfo] {
                self.listTourSpot = result
                self.lbFailed.removeFromSuperview()
                self.reloadData()
            } else {
                self.dataLoadFailed()
            }
        }
    }
    
    func dataLoadFailed() {
        self.addSubview(self.lbFailed)
        self.lbFailed.then {
            $0.text = "데이터 로드 실패"
        }.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}

extension TourSpotCollectionView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    // 셀 데이터 세팅
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cclTourSpot = collectionView.dequeueReusableCell(withReuseIdentifier: TourSpotCell.reusableIdentifier, for: indexPath) as? TourSpotCell else { return TourSpotCell() }
        
        cclTourSpot.layer.masksToBounds = true
        cclTourSpot.layer.cornerRadius = 25.0
        
        if self.listTourSpot.count > 0 {
            return cclTourSpot.then { [unowned self] in
                
                if let title = self.listTourSpot[indexPath.row].title {
                    $0.lbTitle.text = title
                }
                
                if let thumbnail = self.listTourSpot[indexPath.row].thumbnail {
                    $0.ivThumbnail.kf.setImage(with: URL(string: thumbnail), options: nil)
                }
            }
        } else {
            return cclTourSpot.then {
                $0.lbTitle.text = "데이터 로드 전"
            }
        }
    }
    
    
    // 셀 갯수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.listTourSpot.count
    }
    
    // 셀 선택 시 델리게이트 호출
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.listTourSpot.count > 0 {
            tapCellDelegate?.selected(listTourSpot[indexPath.row])
        }
    }
}

extension TourSpotCollectionView: UICollectionViewDelegateFlowLayout {
    
    // 셀 사이즈
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout:UICollectionViewLayout , sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        //셀 즉 TGAreaTourSpotView의 사이즈
        return CGSize(width: self.frame.width/1.5, height: self.frame.height/2)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
}

