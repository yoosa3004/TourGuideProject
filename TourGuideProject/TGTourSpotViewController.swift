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

protocol TourSpotVCDelegate: class {
    func updateData()
}

class TGTourSpotViewController: UIViewController {
    
    
    // 지역 관광지 그리드뷰를 나타내기 위한 container View
    var areaCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        $0.backgroundColor = .purple
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.showsHorizontalScrollIndicator = false
        $0.isPagingEnabled = true
        $0.collectionViewLayout = layout
    }
    
    // 지역 관광지 그리드뷰를 나타내기 위한 container View
    var areaCollectionView2 = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        $0.backgroundColor = .purple
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.showsHorizontalScrollIndicator = false
        $0.isPagingEnabled = true
        $0.collectionViewLayout = layout
    }
    
    // 지역 세그먼트 컨트롤바
    let areaMenuInfos = ["서울", "경기도", "강원도", "전라도", "충청도", "경상도", "제주도"]
    let areaSegmentControl = UISegmentedControl(items: ["서울", "경기도", "강원도", "전라도", "충청도", "경상도", "제주도"]).then {
        $0.selectedSegmentIndex = 0
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // 스크롤뷰
    let areaScrollView = UIScrollView().then {
        $0.backgroundColor = .gray
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // 스택뷰
    let areaStackView = UIStackView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .horizontal
        $0.spacing = 10.0
        $0.backgroundColor = .purple
        $0.distribution = .fillEqually
        $0.alignment = .fill
    }
    
    @objc func changePage(_ segmentedControl: UISegmentedControl) {

        
    }
    
    
    override func loadView() {
        super.loadView()
    
        
        self.view.backgroundColor = .white
        self.view.addSubview(areaSegmentControl)
        areaSegmentControl.snp.makeConstraints { (make) -> Void in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.height.equalTo(60)

        }
        areaSegmentControl.addTarget(self, action: #selector(changePage(_:)), for: .valueChanged)
        
        self.view.addSubview(areaScrollView)
        areaScrollView.snp.makeConstraints { (make) -> Void in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalTo(self.areaSegmentControl.snp.bottom)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
        
        self.areaScrollView.addSubview(areaStackView)
        
        areaStackView.snp.makeConstraints { [unowned self] (make) -> Void in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalTo(self.areaScrollView.snp.top)
            make.bottom.equalTo(self.areaScrollView.snp.bottom)
            make.height.equalTo(self.areaScrollView.snp.height)
        }
        
        NSLog("test")
        setupAreaCollectionView()
        
        // 델리게이트
        areaScrollView.delegate = self
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        // MARK: iOS 계층구조에 있다고해서 모든 상위 계층에 접근할 수 있는게 아님. 이 경우 바로 상위계층인 tabBarController에서 title 세팅 필요.
        self.tabBarController?.title = "관광지"
    }
    
    func setupAreaCollectionView(){
        
         self.areaStackView.addArrangedSubview(areaCollectionView)
        self.areaStackView.addArrangedSubview(areaCollectionView2)

        areaCollectionView.then {
            $0.delegate = self
            $0.dataSource = self
            $0.register(UINib(nibName: TGTourSpotCell.reusableIdentifier, bundle: nil), forCellWithReuseIdentifier: TGTourSpotCell.reusableIdentifier)
        }.snp.makeConstraints {
            $0.width.equalTo(self.view)
        }
        
        areaCollectionView2.then {
            $0.delegate = self
            $0.dataSource = self
            $0.register(UINib(nibName: TGTourSpotCell.reusableIdentifier, bundle: nil), forCellWithReuseIdentifier: TGTourSpotCell.reusableIdentifier)
        }.snp.makeConstraints {
            $0.width.equalTo(self.view)
        }
    }
}

//MARK:- UICollectionViewDelegate, UICollectionViewDataSource
extension TGTourSpotViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    // 각 셀 채우기 - 지역 관광지들을 채워야함
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // TGAreaTourSpotView를 셀로 이용한다.
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TGTourSpotCell.reusableIdentifier, for: indexPath) as? TGTourSpotCell else { return TGTourSpotCell() }
        cell.titleLabel.text = "아이우에오"
        return cell
    }


    // 각 섹션의 아이템 갯수 - 지역 관광지 갯수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
}

// 스크롤뷰
extension TGTourSpotViewController: UIScrollViewDelegate {
    
    
}


//MARK:- UICollectionViewDelegateFlowLayout
extension TGTourSpotViewController: UICollectionViewDelegateFlowLayout {
    
    // 각 셀의 사이즈
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout:UICollectionViewLayout , sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        //셀 즉 TGAreaTourSpotView의 사이즈
        return CGSize(width: 250, height: 250)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

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
