//
//  DataModel.swift
//  ZOOVIE
//
//  Created by abc on 29/05/20.
//  Copyright © 2020 Zoovie. All rights reserved.
//

import UIKit
import SwiftyJSON

class DataModel: Decodable {

    let data: String
    let message: String
    let statusCode: Int
    

  required init(json: JSON) {
        data = json["data"].stringValue
        message = json["message"].stringValue
        statusCode = json["statusCode"].intValue
    }

}

