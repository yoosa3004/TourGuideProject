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
import SpringIndicator

class TourSpotCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    // 인디케이터
    let avTourSpotLoading = SpringIndicator(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
    
    // API 로드용 변수
    var mTourSpot = TMTourSpot()
    var areaCode: Int?
    var arrange: String?
    var loadedPageNo: Int = 1
    let maxPageNo: Int = 10
    
    // 데이터
    var listTourSpot = Array<TourSpotInfo>()
    
    // 데이터 로드 실패 시 띄울 라벨
    let lbFailed = UILabel()
    
    // 셀 배치 변수
    var cellsPerRow: CGFloat = 2
    let cellPadding: CGFloat = 10
    let cellHeightRatio: CGFloat = 1.25
    
    override func loadView() {
        super.loadView()
        
        // 인디케이터
        self.view.addSubview(avTourSpotLoading)
        avTourSpotLoading.then { [unowned self] in
            $0.center = CGPoint(x: self.view.center.x, y: self.view.center.y - 100)
            $0.lineColor = .red
        }.start()
        
        // 콜렉션 뷰 세팅
        setCollectionView()
    }
    
    func setCollectionView() {
        
        self.collectionView.then { [unowned self] in
            
            $0.backgroundColor = .white
            
            // 델리게이트
            $0.delegate = self
            $0.dataSource = self
            
            // 레이아웃
            $0.collectionViewLayout = UICollectionViewFlowLayout().then {
                $0.scrollDirection = .vertical
                $0.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
            }
            
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.showsHorizontalScrollIndicator = false
            
            // 셀 등록
            $0.register(TourSpotCell.self, forCellWithReuseIdentifier: TourSpotCell.reusableIdentifier)
            
            // 리프레쉬 컨트롤
            $0.cr.addHeadRefresh(animator: NormalHeaderAnimator()) { [unowned self] in
                self.refreshTourSpotData()
            }
            
            // 푸터
            $0.cr.addFootRefresh(animator: NormalFooterAnimator()) { [unowned self] in
                if self.loadedPageNo < self.maxPageNo {
                    self.avTourSpotLoading.start()
                    self.loadMoreData()
                }
            }
        }
    }
    
    func refreshTourSpotData() {
        self.collectionView.reloadData()
        self.collectionView.cr.endHeaderRefresh()
    }
    
    func loadMoreData() {
        mTourSpot.pageNo = loadedPageNo + 1
        mTourSpot.requestAPI { (apiResult) -> Void in
            if let result = apiResult as? [TourSpotInfo] {
                self.lbFailed.removeFromSuperview()
                self.listTourSpot.append(contentsOf: result)
                self.collectionView.reloadData()
                self.loadedPageNo += 1
            }
            
            self.avTourSpotLoading.stop()
            
            if self.loadedPageNo == self.maxPageNo {
                self.collectionView.cr.noticeNoMoreData()
            } else {
                self.collectionView.cr.endLoadingMore()
            }
        }
    }
    
    func loadData() {
        mTourSpot.requestAPI { (apiResult) -> Void in
            if let result = apiResult as? [TourSpotInfo] {
                self.listTourSpot = result
                self.collectionView.reloadData()
            } else {
                self.dataLoadFailed()
            }
            
            self.avTourSpotLoading.stop()
        }
    }
    
    func dataLoadFailed() {
        self.view.addSubview(self.lbFailed)
        self.lbFailed.then {
            $0.text = "데이터 로드 실패"
        }.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    // 셀 눌린 경우
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let parent = self.parent as? TourSpotListViewController {
            
            // 상세화면 세팅
            let vcTourSpotDetail = CMDetailViewController().then {
                $0.tourSpotInfo = listTourSpot[indexPath.row]
                $0.dataType = .TourSpot
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
        
        let widthMinusPadding = self.view.frame.width - (cellPadding + cellPadding * cellsPerRow)
        let eachWidth = widthMinusPadding / cellsPerRow
        return CGSize(width: eachWidth, height: eachWidth * cellHeightRatio)
    
    }
}
