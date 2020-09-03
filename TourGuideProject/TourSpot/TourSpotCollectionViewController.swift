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
import RxSwift
import RxCocoa

class TourSpotCollectionViewController: UIViewController, UICollectionViewDelegateFlowLayout {
    
    
    // 콜렉션뷰
    lazy var cvTourSpot: UICollectionView = {
        let layout = UICollectionViewFlowLayout().then {
            $0.scrollDirection = .vertical
            $0.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        }
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.purple
        return cv
    }()
    
    var disposeBag = DisposeBag()
    
    // 인디케이터
    let avTourSpotLoading = SpringIndicator(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
    
    // API 로드용 변수
    var mTourSpot = TMTourSpot()
    var areaCode: Int?
    var loadedPageNo: Int = 1
    
    // 데이터
    var listTourSpot = Array<TourSpotInfo>()
    
    // 데이터 로드 실패 시 띄울 라벨
    let lbFailed = UILabel()
    
    // 셀 배치 변수
    var cellsPerRow: CGFloat = 2
    let cellPadding: CGFloat = 10
    let cellHeightRatio: CGFloat = 1.25
    
    var isInitData: Bool = false
    
    override func loadView() {
        super.loadView()
        
        // 인디케이터
        self.view.addSubview(avTourSpotLoading)
        avTourSpotLoading.then { [unowned self] in
            $0.center = CGPoint(x: self.view.center.x, y: self.view.center.y - 100)
            $0.lineColor = .red
        }
        
        // 콜렉션 뷰 세팅
        setCollectionView()
        
        setUpCollectionViewBinding()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
        self.mTourSpot.tourSpotObservable
            .bind(to: self.collectionView.rx.items(cellIdentifier: TourSpotCell.reusableIdentifier, cellType: TourSpotCell.self)) {
                row, data, cell in
                
                cell.lbTitle.text = data.title
                
                
//                if let thumbnail = element[index].thumbnail {
//                    cell.ivThumbnail.kf.setImage(with: URL(string: thumbnail), options: nil)
//                }
                
        }.disposed(by: disposeBag)
        */
//        mTourSpot.tourSpotObservable
//            .bind(to: self.collectionView.rx.items(cellIdentifier: TourSpotCell.reusableIdentifier, cellType: TourSpotCell.self)) {
//                (index: Int, element: [TourSpotInfo], cell: TourSpotCell) in
//
//                cell.lbTitle.text = elemenindex].title
//
//                if let thumbnail = element[index].thumbnail {
//                    cell.ivThumbnail.kf.setImage(with: URL(string: thumbnail), options: nil)
//                }
//        }
    }
    
    func setCollectionView() {
        
        self.view.addSubview(cvTourSpot)
        cvTourSpot.then { [unowned self] in
            
            $0.backgroundColor = .white
            
            // 델리게이트
//            $0.delegate = self
//            $0.dataSource = self
            
            // 레이아웃
//            $0.collectionViewLayout = UICollectionViewFlowLayout().then {
//                $0.scrollDirection = .vertical
//                $0.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
//            }
            
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.showsHorizontalScrollIndicator = false
            
            // 셀 등록
            $0.rx.setDelegate(self).disposed(by: disposeBag)
            $0.register(TourSpotCell.self, forCellWithReuseIdentifier: TourSpotCell.reusableIdentifier)
            
            // 데이터가 없을 때도 pull-down 할 수 있게
            $0.alwaysBounceVertical = true
            
            // 리프레쉬 컨트롤
            $0.cr.addHeadRefresh(animator: NormalHeaderAnimator()) { [unowned self] in
                self.refreshTourSpotData()
            }
            
            // 푸터
            $0.cr.addFootRefresh(animator: NormalFooterAnimator()) { [unowned self] in
                if self.loadedPageNo <= self.mTourSpot.maxPageNo {
                    self.loadData()
                }
            }
        }
    }
    
    func setUpCollectionViewBinding() {
        
        mTourSpot.tourSpotObservable
            .bind(to: cvTourSpot.rx.items(cellIdentifier: TourSpotCell.reusableIdentifier, cellType: TourSpotCell.self)) {
                row, element, cell in
                
//                guard let tourSpotCell: TourSpotCell = cell else { return }
                
                cell.lbTitle.text = element.title
                print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ \(element.title)")
                
            
        }.disposed(by: disposeBag)
    }
    
    
    // 1. 데이터가 있는 상황에서 reload, 2. 데이터 로드 실패 화면에서 reload
    func refreshTourSpotData() {
    
        if self.listTourSpot.isEmpty == false {
            self.listTourSpot.removeAll()
            self.cvTourSpot.reloadData()
        }
        
        self.loadedPageNo = 1
        self.loadData()
        self.cvTourSpot.cr.endHeaderRefresh()
    }
    
    // 1. init 2. refresh 3. load more
    func loadData() {
        
        // 인디케이터 시작
        self.avTourSpotLoading.start()
        
        mTourSpot.pageNo = loadedPageNo
        
        mTourSpot.requestAPIRx()
        
        /*
        mTourSpot.requestAPI { [unowned self] (apiResult) -> Void in
            
            // 전에 데이터 로드가 실패했다면 라벨 삭제
            self.lbFailed.removeFromSuperview()
            
            // 데이터 로드 성공
            if let result = apiResult as? [TourSpotInfo] {
                
                // 실제 데이터에 insert
                self.listTourSpot.append(contentsOf: result)
                self.cvTourSpot.reloadData()
                
                // 다음 로드를 위해 pageNo + 1
                self.loadedPageNo += 1
            }
            // 데이터 로드 실패
            else {
                self.loadDataFailed()
            }
            
            // 인디케이터 멈추기
            self.avTourSpotLoading.stop()
            
            // 설정값 만큼 로딩했을 시 no more Data 해주기
            if self.loadedPageNo > self.mTourSpot.maxPageNo {
                self.cvTourSpot.cr.noticeNoMoreData()
            } else {
                self.cvTourSpot.setContentOffset(self.cvTourSpot.contentOffset, animated: true)
                self.cvTourSpot.cr.endLoadingMore()
            }
        }
 */
        
        
    }
    
    func loadDataFailed() {
        
        // 인디케이터 삭제
        self.avTourSpotLoading.stop()
        
        // 데이터가 아에 로드되지 않았을 경우(1. init에서 들어오거나 2. 데이터가 있는 상태에서 인터넷연결 해제 후 reload 시도한 경우)
        if listTourSpot.isEmpty {
            self.view.addSubview(self.lbFailed)
            self.lbFailed.then {
                $0.text = "데이터 로드 실패"
            }.snp.makeConstraints {
                $0.center.equalToSuperview()
            }
        }
        // load more Data 에서 데이터 로딩 실패했을 경우 Toast
        else {
            String("데이터 로드에 실패했습니다!!").showToast()
        }
    }
    


    // 셀 데이터 세팅
    /*
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
         return 10
     }
     
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
    
 */
    
    // 셀 사이즈
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout:UICollectionViewLayout , sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let widthMinusPadding = self.view.frame.width - (cellPadding + cellPadding * cellsPerRow)
        let eachWidth = widthMinusPadding / cellsPerRow
        return CGSize(width: eachWidth, height: eachWidth * cellHeightRatio)
    }
     


}
