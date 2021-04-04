//
//  ImageModel.swift
//  ZOOVIE
//
//  Created by SFS on 06/06/20.
//  Copyright © 2020 Zoovie. All rights reserved.
//

import UIKit

class ImageModel: Codable {
    var message:String?
    var statusCode:Int?
    var data:ImageData?
    var type:String?
}
struct ImageData: Codable {
    var original:String?
    var thumb:String?
}
