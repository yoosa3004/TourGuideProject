//
//  FestivaListTableViewController.swift
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

class FestivaListTableViewController: UIViewController {
    
    // 모델
    let mFestivals = TMFestivals()
    var loadedPageNo: Int = 1
    
    // 리프레쉬 컨트롤
    let rcrFestical = UIRefreshControl()
    
    // 데이터
    var listFestivalInfo = Array(repeating: [FestivalInfo](), count: 12)
    
    // 인디케이터
    let avFestivalLoading = SpringIndicator(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
    
    // 테이블뷰
    var tbvFestivalInfo = UITableView()

    override func loadView() {
        super.loadView()
        
        setViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.title = "행사"
    }
    
    func loadDataFailed() {
        let lbDataLoadFailed = UILabel(frame: self.tbvFestivalInfo.bounds)
        lbDataLoadFailed.text = "데이터 로드 실패"
        lbDataLoadFailed.textAlignment = .center
        self.tbvFestivalInfo.backgroundView = UIView(frame: self.tbvFestivalInfo.bounds)
        self.tbvFestivalInfo.backgroundView?.addSubview(lbDataLoadFailed)
    }

    func setViews() {
        
        // 배경
        self.view.backgroundColor = .white
        
        // 테이블 뷰
        self.view.addSubview(tbvFestivalInfo)
        tbvFestivalInfo.then {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.register(FestivalCell.self, forCellReuseIdentifier: FestivalCell.reusableIdentifier)
            $0.delegate = self
            $0.dataSource = self
            
            // 리프레시 컨트롤
            $0.refreshControl  = rcrFestical
            $0.refreshControl?.addTarget(self, action: #selector(refreshFestivalData(_:)), for: .valueChanged)
            
            /*
             $0.cr.addFootRefresh(animator: NormalFooterAnimator()) { [weak self] in
             guard let self = self else {return}
             
             if self.loadedPageNo < 10 {
             self.avFestivalLoading.start()
             self.loadMoreFestivalData()
             }
             }*/
        }.snp.makeConstraints {
            $0.top.bottom.left.right.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        // 인디케이터
        self.view.addSubview(self.avFestivalLoading)
        self.view.bringSubviewToFront(self.avFestivalLoading)
        avFestivalLoading.then {
            let validCenter = CGPoint(x: self.view.center.x, y: self.view.center.y)
            $0.center = validCenter
            $0.lineColor = .red
        }.start()
        
    }
    
    @objc func refreshFestivalData(_ sender: Any) {
        self.tbvFestivalInfo.reloadData()
        self.tbvFestivalInfo.refreshControl?.endRefreshing()
    }
    
    func loadMoreFestivalData() {
        mFestivals.eventStartDate = 20200101
        mFestivals.arrange = "P"
        mFestivals.pageNo = self.loadedPageNo + 1
        
        mFestivals.requestAPI { [unowned self] in
            if let sortedInfo = $0 as? [[FestivalInfo]] {
                for idx in sortedInfo.indices {
                    self.listFestivalInfo[idx].append(contentsOf: sortedInfo[idx])
                }
                self.tbvFestivalInfo.reloadData()
                self.loadedPageNo = self.mFestivals.pageNo
            }

            self.avFestivalLoading.stop()
            
            if self.loadedPageNo == 10 {
                self.tbvFestivalInfo.cr.noticeNoMoreData()
            } else {
                self.tbvFestivalInfo.cr.endLoadingMore()
                let indexPath = NSIndexPath(row: NSNotFound, section: 0)
                self.tbvFestivalInfo.scrollToRow(at: indexPath as IndexPath, at: .top, animated: true)
                
            }
        }
    }
    
    /*
     func loadData() {
     mFestivals.eventStartDate = 20200101
     mFestivals.arrange = "P"
     
     mFestivals.requestAPI { [unowned self] in
     if let sortedInfo = $0 as? [[FestivalInfo]] {
     for idx in sortedInfo.indices {
     self.listFestivalInfo[idx] = sortedInfo[idx]
     }
     self.tbvFestivalInfo.reloadData()
     } else {
     self.loadDataFailed()
     }
     
     self.avFestivalLoading.stop()
     }
     }s
     */
    
    func loadData() {
        mFestivals.eventStartDate = 20200101
        mFestivals.arrange = "P"
        
        for pageNo in 1...10 {
            mFestivals.pageNo = pageNo
            
            mFestivals.requestAPI { [unowned self] in
                if let sortedInfo = $0 as? [[FestivalInfo]] {
                    for idx in sortedInfo.indices {
                        self.listFestivalInfo[idx].append(contentsOf: sortedInfo[idx])
                    }
                } else {
                    self.loadDataFailed()
                    self.avFestivalLoading.stop()
                    return
                }
            if pageNo == 10 {
                self.tbvFestivalInfo.reloadData()
                self.avFestivalLoading.stop()
            }
            
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
    }
}

extension FestivaListTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if listFestivalInfo.count > 0 {
            return listFestivalInfo[section].count
        }else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cclFestivalInfo = tableView.dequeueReusableCell(withIdentifier: FestivalCell.reusableIdentifier, for: indexPath) as? FestivalCell else {return FestivalCell()}
        // 셀 세팅
        if listFestivalInfo[indexPath.section].count > 0 {
            return cclFestivalInfo.then {
                let data = listFestivalInfo[indexPath.section][indexPath.row]
                
                // 행사 제목
                if let title = data.title {
                    if title.contains("[") {
                        $0.lbTitle.attributedText = NSAttributedString().splitByBracket(title)
                    } else {
                        $0.lbTitle.text = title
                    }
                }
                
                // 행사 주소
                if let str = data.addr1 {
                    $0.lbAddr.text = str
                    if let str2 = data.addr2 {
                        $0.lbAddr.text = str+str2
                    }
                }
                
                // 행사 날짜
                if let startDate = data.eventstartdate {
                    if let endDate = data.eventenddate {
                        let convertedEventDate = String(startDate.changeDateFormat()) + " ~ " + String(endDate.changeDateFormat())
                        $0.lbDate.text = convertedEventDate
                        data.convertedEventDate = convertedEventDate
                    }
                }
                
                // 행사 이미지
                if let thumbnail = data.thumbnail {
                    $0.ivFestival.kf.setImage(with: URL(string: thumbnail), options: nil)
                }
            }
        } else {
            return cclFestivalInfo
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.height/5
    }
    
    // 셀 클릭시 델리게이트 호출
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vDetail = CMDetailViewController().then {
            $0.festivalInfo = listFestivalInfo[indexPath.section][indexPath.row]
            $0.dataType = .Festival
        }
        
        self.navigationController?.pushViewController(vDetail, animated: true)
    }
    
    // 섹션 갯수
    func numberOfSections(in tableView: UITableView) -> Int {
        return 12
    }
    
    
    // 행사가 없는 달의 섹션은 보이지 않게함
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if listFestivalInfo.count == 0 { return 0 }
        
        if listFestivalInfo[section].count == 0 {
            return CGFloat.leastNormalMagnitude
        } else {
            return 40
        }
    }
    
    // 헤더 뷰
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 40))
        view.backgroundColor = .systemGray5
        
        let ivHeader = UIImageView()
        view.addSubview(ivHeader)
        ivHeader.then {
            $0.image = UIImage(named: "happiness.png")
        }.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.centerY.equalToSuperview()
        }
        
        let lbHeader = UILabel()
        view.addSubview(lbHeader)
        lbHeader.then {
            $0.text = "\(section+1)월"
            $0.textAlignment = .center
            $0.textColor = .black
        }.snp.makeConstraints {
            $0.left.equalTo(ivHeader.snp.right).offset(10)
            $0.top.bottom.equalToSuperview()
        }
        
        return view
    }
}
