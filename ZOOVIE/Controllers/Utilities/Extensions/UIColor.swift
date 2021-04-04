//
//  UIColor.swift
//  ZOOVIE
//
//  Created by abc on 5/6/20.
//  Copyright © 2020 ZOOVIE. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(hexString: String, alpha: CGFloat = 1) {
       var cString: String = hexString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
       
       if cString.hasPrefix("#") {
         cString.remove(at: cString.startIndex)
       }
       
       if (cString.count) != 6 {
         self.init()
         return
       }
       
       var rgbValue: UInt32 = 0
       Scanner(string: cString).scanHexInt32(&rgbValue)
       
       self.init(
         red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
         green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
         blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
         alpha: CGFloat(alpha)
       )
     }
}
