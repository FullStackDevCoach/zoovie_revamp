//
//  CitiesModel.swift
//  ZOOVIE
//
//  Created by SFS on 03/06/20.
//  Copyright © 2020 Zoovie. All rights reserved.
//

import UIKit

struct CitiesModel : Decodable {
    let statusCode : Int?
    let message : String?
    let data : [Cities]?
}
struct Cities : Decodable {
    let state_id : String?
    let state_name : String?
    let id : Int?
    let location : Location?
    let city : String?
}

struct Location : Decodable {
    let type : String?
    let coordinates : [Double]?
}

