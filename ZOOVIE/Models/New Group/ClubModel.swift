//
//  ClubModel.swift
//  ZOOVIE
//
//  Created by SFS on 03/06/20.
//  Copyright © 2020 Zoovie. All rights reserved.
//

import UIKit


class ClubModel: Decodable{
    let statusCode : Int?
    let message : String?
    let data : [ClubsData]?
}
class ClubsData:Decodable {
    var __v:Int?
    var _id:String?
    var address:String?
    var createdAt:String?
    var images:[Image]?
    var location:Coordinates?
    var accessToken:String?
    var type:String?
    var name:String?
    var rating:Double?
    var ratingCount:Int?
    var reviews:[ReviewData]?
    var pastEvent:[Events]?
    var upcomingEvent:[Events]?
}

class Coordinates: Codable {
    var coordinates:[Double]?
    var type:String?
}

class Events:Codable {
    var __v:Int?
    var _id:String?
    var about:String?
    var address:String?
    var city: String?
    var artist:[String]?
    var clubId:String?
    var createdAt:String?
    var date:String?
    var images:[Image]?
    var location:Coordinates?
    var name:String?
    var performancePrice:Int?
    var performanceSlot:[PerformanceSlot]?
    var tags:[String]?
    var termAndCondition:String
    var general:PriseAndQuantity?
    var vipGeneral:PriseAndQuantity?
    var vipSection:PriseAndQuantity?
    //var totalComments:Int?
    var totalLikes:Int?
    var isLike: Bool?
    
}

class PerformanceSlot: Codable {
    var end:String?
    var start:String?
    var _id:String?

}

class PriseAndQuantity: Codable {
    var price:Double?
    var quantity:Double?
}
class Image: Codable {
    var original:String?
    var thumbnail:String?
    var order:Int?
    var _id:String?
}
class ReviewData: Decodable {
    var _id:String?
    var comment:String?
    var rating:Double?
    var timeStamp:Double?
    var userId:UserData?
}
