//
//  LoginModel.swift
//  ZOOVIE
//
//  Created by abc on 31/05/20.
//  Copyright © 2020 Zoovie. All rights reserved.
//

import UIKit
import Foundation

struct LoginModel : Decodable {
    let statusCode : Int?
    let message : String?
    let data : UserData?
}

class UserData: Decodable{
    var __v:Int?
    var _id:String?
    var accessToken:String?
    var countryCode:String?
    var createdAt:String?
    var deviceToken:String?
    var deviceType:String?
    var email:String?
    var bio:String?
    var faceBookId:String?
    var firstName:String?
    var lastName:String?
    var password:String?
    var phoneNo:String?
    var userName:String?
    var version:String?
    var longitude:String?
    var latitude:String?
    var address:String?
    var status:String?
    var totalConnections:Int?
    var stories:[StoryData]?
    var image:Image?
    var connection:Int?
   // var artist:String?
    var lastLogin:String?
    var location:Coordinates?
    var placeVisted:[Places]?
   // var reviews:[Reviews]?
    var artist:Bool?
    var isNewUser: Bool?
}
struct UserImage : Decodable {
    let original : String?
    let thumbnail : String?
}
class Reviews: Codable {
    var _id:String?
    var images:[Image]?
    var name:String?
    var reviews:[ReviewEntity]?
}

class ReviewEntity: Codable {
    var _id:String?
    var comment:String?
    var rating:Double?
    var timeStamp:Double?
    var userId:String?
}

class StoryData: Codable {
    var __v:Int?
    var _id:String?
    var createdAt:String?
    var date:String?
    var image:Image?
    var userId:String?
}

class Places: Decodable {
    var _id:String?
    var clubId:PlacesEntity?
}
class PlacesEntity: Codable {
    var _id:String?
    var address:String?
    var images:[Image]?
    var name:String?
}
