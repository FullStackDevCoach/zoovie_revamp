//
//  UITableView+Register.swift
//  MailApp
//
//  Created by abc on 17/04/19.
//  Copyright © 2020 ZOOVIE. All rights reserved.
//

import UIKit

extension UITableView {
    func register(name: String) {
        self.register(UINib(nibName: name, bundle: nil), forCellReuseIdentifier: name)
    }
    func setBackgroundView(message:String) {
       // let view = UIView(frame: self.frame)
        let label = UILabel()
        label.text = message
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.font = UIFont(name: Constants.AppFont.kFontBold, size: 18.0)
        label.center = CGPoint(x: self.center.x, y: self.center.y - 60)
        self.backgroundView = label
    }
}
