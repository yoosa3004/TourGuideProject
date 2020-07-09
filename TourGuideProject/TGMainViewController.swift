//
//  MainViewController.swift
//  TourGuideProject
//
//  Created by hyunndy on 2020/07/09.
//  Copyright © 2020 hyunndy. All rights reserved.
//



// 새로운 뷰로 들어갈 때 hidesBottomBarWhenPushed = true 설정

import UIKit
import Then
import SnapKit

final class TGMainViewController: UIViewController{

    let testLabel = UILabel().then {
        $0.text = "안녕하세요"
        $0.textColor = .black
        $0.textAlignment = .center
        $0.bounds = CGRect(x: 0, y: 0, width: 100, height: 100)
        $0.backgroundColor = .purple
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.view.backgroundColor = UIColor.white
        
        
        setUpView()
    }
    

    private func setUpView() {
        
        self.view.addSubview(self.testLabel)
        
        self.testLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
