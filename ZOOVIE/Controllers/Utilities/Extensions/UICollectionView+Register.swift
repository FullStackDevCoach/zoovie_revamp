//
//  UICollectionView+Register.swift
//  ZOOVIE
//
//  Created by abc on 17/04/19.
//  Copyright © 2019 ZOOVIE. All rights reserved.
//

import UIKit

extension UICollectionView {
    func register(name: String) {
        self.register(UINib(nibName: name, bundle: nil), forCellWithReuseIdentifier: name)
    }
}
