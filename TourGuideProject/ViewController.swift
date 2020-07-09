//
//  ViewController.swift
//  TourGuideProject
//
//  Created by hyunndy on 2020/07/07.
//  Copyright © 2020 hyunndy. All rights reserved.
//

import UIKit
import Then


class ViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // API로부터 Data 받아오기
        TGNetworkingManager().loadData()
        print("네 안녕하세요")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    


}

