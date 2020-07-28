//
//  DrawerViewController.swift
//  TourGuideProject
//
//  Created by hyunndy on 2020/07/28.
//  Copyright © 2020 hyunndy. All rights reserved.
//

import UIKit
import Then
import SnapKit
import KYDrawerController

class DrawerViewController: UIViewController {

    let btnClose = UIButton()
    
    override func loadView() {
        super.loadView()
        
        self.view.backgroundColor = .white
        
        self.view.addSubview(btnClose)
        btnClose.then { [unowned self] in
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.setTitle("Close", for: UIControl.State())
            $0.addTarget(self, action: #selector(onTapCloseBtn(_:)), for: .touchUpInside)
            $0.setTitleColor(.systemIndigo, for: UIControl.State())
        }.snp.makeConstraints { [unowned self] in
            $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(20)
            $0.right.equalToSuperview().offset(-30)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @objc func onTapCloseBtn(_ sender: UIButton) {
        if let drawerController = parent as? KYDrawerController {
            drawerController.setDrawerState(.closed, animated: true)
        }
    }
}
