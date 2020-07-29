//
//  TourSpotCollectionViewController.swift
//  TourGuideProject
//
//  Created by hyunndy on 2020/07/29.
//  Copyright © 2020 hyunndy. All rights reserved.
//

import UIKit
import Then
import SnapKit
import CRRefresh

class TourSpotCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    // API 로드 모델
    var mTourSpot = TMTourSpot()
    var areaCode: Int?
    var arrange: String?
    
    // 데이터
    var listTourSpot = Array<TourSpotInfo>()
    
    // 데이터 로드 실패 시 띄울 라벨
    let lbFailed = UILabel()
    
    func dataLoadFailed() {
        self.view.addSubview(self.lbFailed)
        self.lbFailed.then {
            $0.text = "데이터 로드 실패"
        }.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    override func loadView() {
        super.loadView()
        
        // 콜렉션 뷰 세팅
        setCollectionView()
    }
    
    func setCollectionView() {
        
        self.collectionView.then { [weak self] in
            
            // 델리게이트
            $0.delegate = self
            $0.dataSource = self
            
            // 레이아웃
            $0.collectionViewLayout = UICollectionViewFlowLayout().then {
                $0.scrollDirection = .vertical
            }
            
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.showsHorizontalScrollIndicator = false
            
            // 셀
            $0.register(TourSpotCell.self, forCellWithReuseIdentifier: TourSpotCell.reusableIdentifier)
            
            // 리프레쉬 컨트롤
            $0.cr.addHeadRefresh(animator: NormalHeaderAnimator()) { [weak self] in
                self?.refreshTourSpotData()
            }
            
            $0.cr.addFootRefresh(animator: NormalFooterAnimator()) { [weak self] in
                self?.loadMoreTourSpotData()
            }
        }
    }
    
    func refreshTourSpotData() {
        self.collectionView.cr.endHeaderRefresh()
    }
    
    func loadMoreTourSpotData() {
        self.collectionView.cr.endLoadingMore()
    }
    
    func loadData() {
        
        mTourSpot.requestAPI { (apiResult) -> Void in
            if let result = apiResult as? [TourSpotInfo] {
                self.listTourSpot = result
                self.lbFailed.removeFromSuperview()
                self.collectionView.reloadData()
            } else {
                self.dataLoadFailed()
            }
        }
    }
    
    // 셀 눌린 경우
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let parent = self.parent as? TourSpotListViewController {
            
            let vcTourSpotDetail = TourSpotDetailViewController().then{
                $0.tourSpotInfo = listTourSpot[indexPath.row]
            }
            
            parent.navigationController?.pushViewController(vcTourSpotDetail, animated: true)
        }
    }
    
    // 셀 갯수
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.listTourSpot.count
    }
    
    // 셀 데이터 세팅
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
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
    
    // 셀 사이즈
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout:UICollectionViewLayout , sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        //셀 즉 TGAreaTourSpotView의 사이즈
        return CGSize(width: self.view.frame.width/1.5, height: self.view.frame.height/2)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
}
