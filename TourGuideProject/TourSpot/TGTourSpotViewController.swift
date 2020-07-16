//
//  TGTourSpotViewController.swift
//  TourGuideProject
//
//  Created by hyunndy on 2020/07/09.
//  Copyright © 2020 hyunndy. All rights reserved.
//

import UIKit
import SnapKit
import Then
import ScrollableSegmentedControl

class TGTourSpotViewController: UIViewController {
    
    // 스택뷰 안에 들어갈 컬렉션뷰 배열
    var collectionViewArray = Array<TGTourSpotCollectionView>()
    
    // 세그먼트 컨트롤
    let areaSegmentControl = UISegmentedControl(items: areaMenu)

    // 스크롤뷰
    let areaScrollView = UIScrollView()
    
    // 스택뷰
    let areaStackView = UIStackView()
    
    func setupFrameViews() {
        
        // 세그먼트 컨트롤 뷰
        self.view.addSubview(areaSegmentControl)
        areaSegmentControl.then{
            $0.selectedSegmentIndex = 0
            $0.translatesAutoresizingMaskIntoConstraints = false
        }.snp.makeConstraints { [unowned self] (make) -> Void in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.height.equalTo(60)

        }
        areaSegmentControl.addTarget(self, action: #selector(changePage(_:)), for: .valueChanged)
        
        // 스크롤 뷰
        self.view.addSubview(areaScrollView)
        areaScrollView.then {
            $0.backgroundColor = .gray
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.delegate = self
            $0.isPagingEnabled = true
        }.snp.makeConstraints { [unowned self] (make) -> Void in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalTo(self.areaSegmentControl.snp.bottom)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
        
        // 스택 뷰
        self.areaScrollView.addSubview(areaStackView)
        areaStackView.then {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.axis = .horizontal
            $0.backgroundColor = .purple
            
            // axis와 함께 사용되는 가로/세로의 개념
            $0.distribution = .fillEqually
            $0.alignment = .fill
        }.snp.makeConstraints { [unowned self] (make) -> Void in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalTo(self.areaScrollView.snp.top)
            make.bottom.equalTo(self.areaScrollView.snp.bottom)
            make.height.equalTo(self.areaScrollView.snp.height)
        }
    }
    
    override func loadView() {
        super.loadView()
    
        self.view.backgroundColor = .white
        
        setupFrameViews()
        initCollectionView()
    }
    
    func initCollectionView() {
        
        for idx in areaMenuCode.indices {
            
            let collectionView = TGTourSpotCollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then { [weak self] in
                $0.areaNum = areaMenuCode[idx]
                $0.tapCellDelegate = self
                let layout = UICollectionViewFlowLayout()
                layout.scrollDirection = .vertical
                
                $0.backgroundColor = .purple
                $0.translatesAutoresizingMaskIntoConstraints = false
                $0.showsHorizontalScrollIndicator = false
                $0.isPagingEnabled = true
                $0.collectionViewLayout = layout
                
                $0.delegate = $0
                $0.dataSource = $0
                $0.register(UINib(nibName: TGTourSpotCell.reusableIdentifier, bundle: nil), forCellWithReuseIdentifier: TGTourSpotCell.reusableIdentifier)
            }
            
            collectionViewArray.append(collectionView)
            self.areaStackView.addArrangedSubview(collectionViewArray[idx])
            
            collectionViewArray[idx].snp.makeConstraints { [unowned self] (make) -> Void in
                make.width.equalTo(self.view)
            }
            
            collectionViewArray[idx].loadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let a = TGFestivalViewController()
        self.tabBarController?.navigationController?.pushViewController(a, animated: false)
        self.navigationController?.pushViewController(a, animated: false)
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // MARK: iOS 계층구조에 있다고해서 모든 상위 계층에 접근할 수 있는게 아님. 이 경우 바로 상위계층인 tabBarController에서 title 세팅 필요.
        self.tabBarController?.title = "관광지"
    }
    
    @objc func changePage(_ segmentedControl: UISegmentedControl) {
        
        let screenWidth = UIScreen.main.bounds.maxX
        let idx = CGFloat(segmentedControl.selectedSegmentIndex)
        
        areaScrollView.contentOffset.x = screenWidth*idx
    }
}
 
 // 스크롤뷰
 extension TGTourSpotViewController: UIScrollViewDelegate {

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        // 스크롤뷰의 사이즈
        let x = scrollView.contentOffset.x
        // 현재 디바이스 화면의 사이즈
        let screenWidth = UIScreen.main.bounds.maxX
        // 넓은 백지인 스크롤뷰에서 현재 보여지고있는 뷰의 위치
        areaSegmentControl.selectedSegmentIndex = Int(x/screenWidth)
    }

 }

// 개별 셀 클릭 시 불리는 프로토콜
extension TGTourSpotViewController: TGTourSpotCellDelegate {
    func selected(_ detailInfo: TourData) {
        let detailView = TGTourSpotDetailViewController().then {
            $0.dataInfo = detailInfo
        }
        self.navigationController?.pushViewController(detailView, animated: false)
    }
}


// 딜리 로그 함수
public func DLog(tag: String, _ object: Any, functionName: String = #function, fileName: String = #file, lineNumber: Int = #line) {
  #if DEBUG
  let className = (fileName as NSString).lastPathComponent
  print("<\(className)> \(functionName) #\(lineNumber) \(NSDate())\n [\(tag)]\(object)\n")
  #else
  if CMEasterEgg.isReleaseLog == true {
    let className = (fileName as NSString).lastPathComponent
    os_log("%{public}s\n[%{public}s] %{public}s","<\(className)> \(functionName) #\(lineNumber) \(NSDate())",tag,"\(object)")
  }
  #endif
}
