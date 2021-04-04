//
//  HomePageModel.swift
//  ZOOVIE
//
//  Created by SFS on 08/06/20.
//  Copyright © 2020 Zoovie. All rights reserved.
//

import UIKit

class HomePageModel: Decodable {
    var message:String?
    var statusCode:Int?
    var data:HomePageData?
}

class State: Codable {
    var data:StateData?
}
class StateData: Codable {
    var states:[states]?
}
class states: Codable {
    var _id:String?
    var name:String?
}

class HomePageData: Decodable {
    var clubs:[VenuesData]?
    //var events:[Events]?
}

class VenuesData:Decodable {
    var __v:Int?
    var _id:String?
    var address:String?
    var createdAt:String?
    var images:[Image]?
    var city:String?
    //var location:Coordinates?
    //var type:String?
    var name:String?
    var rating:Double?
    var ratingCount:Int?
   // var reviews:[ReviewData]?
    //var pastEvent:[Events]?
    //var upcomingEvent:[Events]?
}




