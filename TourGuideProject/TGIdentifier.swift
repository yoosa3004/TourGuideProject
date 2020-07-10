//
//  TGIdentifier.swift
//  TourGuideProject
//
//  Created by hyunndy on 2020/07/10.
//  Copyright © 2020 hyunndy. All rights reserved.
//

import Foundation

extension NSObject {
    static var reusableIdentifier: String {
        return String(describing: self)
    }
}
