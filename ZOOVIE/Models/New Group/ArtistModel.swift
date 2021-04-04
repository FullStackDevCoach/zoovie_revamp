//
//  ArtistModel.swift
//  ZOOVIE
//
//  Created by SFS on 03/06/20.
//  Copyright © 2020 Zoovie. All rights reserved.
//

import UIKit

import UIKit
import Foundation

struct ArtistModel : Decodable {
    let statusCode : Int?
    let message : String?
    let data : [ArtistData]?
}

struct ArtistData : Decodable {
    let _id : String?
    let name : String?
    let artist : [Artist]?
    let tags : [String]?
    let about : String?
    let termAndCondition : String?
    let performancePrice : Int?
    let createdAt : String?
    let insertDate : String?
    let city : String?
    let status : String?
}
struct Artist : Decodable {
    let _id : String?
    let firstName : String?
    let lastName : String?
    let userName : String?
    let image : UserImage?
    var status: Int?
}
