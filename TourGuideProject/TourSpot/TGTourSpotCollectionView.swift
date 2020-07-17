//
//  TGTourSpotCollectionView2.swift
//  TourGuideProject
//
//  Created by hyunndy on 2020/07/16.
//  Copyright © 2020 hyunndy. All rights reserved.
//

import UIKit

protocol TGTourSpotCellDelegate: class {
    func selected(_ detailInfo: TourData)
}

class TGTourSpotCollectionView: UICollectionView {
    
    // 델리게이트
    weak var tapCellDelegate: TGTourSpotCellDelegate?

    // 데이터
    var tourInfos = Array<TourData>()
    
    // API 요청변수 - 지역코드
    var areaNum: Int = 0
    // API 요청변수 - 관광코드
    var contentTypeId: Int = 12
    
    func loadData() {
        TGNetworkingManager().loadTourSpotData(areaNum) { [unowned self] (apiData) -> Void in
            self.tourInfos = apiData
            self.reloadData()
        }
    }
    
}

//MARK:- UICollectionViewDelegate, UICollectionViewDataSource
extension TGTourSpotCollectionView: UICollectionViewDataSource, UICollectionViewDelegate {

    // 각 셀 채우기 - 지역 관광지들을 채워야함
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // TGAreaTourSpotView를 셀로 이용한다.
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TGTourSpotCell.reusableIdentifier, for: indexPath) as? TGTourSpotCell else { return TGTourSpotCell() }
        
        if self.tourInfos.count > 0 {
            cell.then { [unowned self] in
                $0.titleLabel.frame = CGRect(x: 0, y: 0, width: cell.frame.width, height: 50)
                $0.titleLabel.text = self.tourInfos[indexPath.row].title
                $0.imageView.frame = CGRect(x: 0, y: 0, width: cell.frame.width/1.5, height: cell.frame.height/1.5)
                $0.setImageView(self.tourInfos[indexPath.row].image!)
            }
        } else {
            cell.titleLabel.text = "데이터로드 전"
        }
        
        return cell
    }


    // 각 섹션의 아이템 갯수 - 지역 관광지 갯수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numOfRows
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("셀이 눌렸습니다")
        
        if self.tourInfos.count > 0 {
          tapCellDelegate?.selected(tourInfos[indexPath.row])
        }
    }
}

//MARK:- UICollectionViewDelegateFlowLayout
extension TGTourSpotCollectionView: UICollectionViewDelegateFlowLayout {
    
    // 각 셀의 사이즈
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout:UICollectionViewLayout , sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        //셀 즉 TGAreaTourSpotView의 사이즈
        return CGSize(width: self.frame.width/1.5, height: self.frame.height/2)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
}

