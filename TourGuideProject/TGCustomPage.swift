//
//  TGCustomPage.swift
//  TourGuideProject
//
//  Created by user on 2020/07/12.
//  Copyright © 2020 hyunndy. All rights reserved.
//

import UIKit
import Then

class TGCustomPage: UICollectionViewCell {

    var label = UILabel().then {
        $0.textColor = .black
        $0.textAlignment = .center
        $0.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.addSubview(label)
        self.backgroundColor = .gray
        label.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }

}
