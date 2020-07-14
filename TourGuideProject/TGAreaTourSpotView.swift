//
//  TGAreaTourSpotView.swift
//  TourGuideProject
//
//  Created by user on 2020/07/12.
//  Copyright © 2020 hyunndy. All rights reserved.
//

import UIKit
import Then

class TGAreaTourSpotView: UICollectionViewCell {

    let appsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), collectionViewLayout: layout)
        collectionView.backgroundColor = .green
        return collectionView
    }()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = .white
        
        
        self.addSubview(appsCollectionView)
        appsCollectionView.delegate = self
        appsCollectionView.dataSource = self
        
        appsCollectionView.snp.makeConstraints { (make) -> Void in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalToSuperview()
        }
       
        appsCollectionView.register(TGTourSpotView.self, forCellWithReuseIdentifier: TGTourSpotView.reusableIdentifier)
        appsCollectionView.translatesAutoresizingMaskIntoConstraints = false
    }

}

extension TGAreaTourSpotView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TGTourSpotView.reusableIdentifier, for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 10, height: 10)
        
    }
}

class TGTourSpotView: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .yellow
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not benn implemented")
    }
}
