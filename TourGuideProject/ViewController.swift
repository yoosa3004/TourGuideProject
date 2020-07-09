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
        
        TGNetworkingManager().loadData()
        
    }


}

