//
//  TGTourSpotCollectionView.swift
//  TourGuideProject
//
//  Created by hyunndy on 2020/07/16.
//  Copyright © 2020 hyunndy. All rights reserved.
//

import UIKit


    
class TGTourSpotCollectionView: NSObject {

    // 콜렉션뷰
    var areaCV = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    // 데이터
    var tourInfos = Array<TourData>()
    
    var areaNum: Int = 0
    
    func loadData() {
        TGNetworkingManager().loadData(areaNum) { [unowned self] (apiData) -> Void in
            self.tourInfos = apiData
            self.areaCV.reloadData()
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
            cell.titleLabel.frame = CGRect(x: 0, y: 0, width: cell.frame.width, height: 50)
            cell.titleLabel.text = self.tourInfos[indexPath.row].title
            cell.imageView.frame = CGRect(x: 0, y: 0, width: cell.frame.width/2, height: cell.frame.height/2)
            cell.setImageView(self.tourInfos[indexPath.row].image!)
        } else {
            cell.titleLabel.text = "데이터로드전"
        }
        
        return cell
    }


    // 각 섹션의 아이템 갯수 - 지역 관광지 갯수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numOfRows
    }
}

//MARK:- UICollectionViewDelegateFlowLayout
extension TGTourSpotCollectionView: UICollectionViewDelegateFlowLayout {
    
    // 각 셀의 사이즈
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout:UICollectionViewLayout , sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        //셀 즉 TGAreaTourSpotView의 사이즈
        return CGSize(width: 250, height: 250)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
}

