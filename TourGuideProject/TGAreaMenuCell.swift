//
//  TGAreaMenuCell.swift
//  TourGuideProject
//
//  Created by hyunndy on 2020/07/10.
//  Copyright © 2020 hyunndy. All rights reserved.
//

import UIKit
import Then

class TGAreaMenuCell: UICollectionViewCell {

    let label = UILabel().then {
        $0.text = "테스트"
        $0.textAlignment = .center
        $0.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        $0.textColor = .lightGray
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override var isSelected: Bool {
        didSet {
            print("Changed")
            self.label.textColor = isSelected ? .black : .lightGray
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.addSubview(label)
        label.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }

}
