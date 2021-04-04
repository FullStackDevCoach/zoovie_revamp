//
//  EventsModel.swift
//  ZOOVIE
//
//  Created by abc on 08/06/20.
//  Copyright © 2020 Zoovie. All rights reserved.
//

import UIKit

struct EventsModel : Decodable {
    let statusCode : Int?
    let message : String?
    var data : [EventData]?
}

struct EventData : Decodable {
    let _id : String?
    let about : String?
    //let artist : [String]?
    let artist : [Artist]?
    let city : String?
    let clubId : ClubId?
    let createdAt : String?
    let date: String?
    let eventDate : String?
    let eventId : String?
    let images : [HomeImages]?
    let insertDate : String?
    var isLike: Bool?
    let name : String?
    var address: String?
    let performancePrice : Int?
    let status : String?
    let tags : [String]?
    let termAndCondition : String?
    let tickets : [Tickets]?
    let performanceSlot : [performanceSlotDetails]?
    var totalComments : Int?
    var totalLikes: Int?
}

struct HomeImages : Decodable {
    let original : String?
    let thumbnail : String?
    let order : Int?
    let _id : String?
}

struct ClubId : Decodable {
    let _id : String?
    let name : String?
    let address : String?
    let images : [HomeImages]?
}

struct Tickets : Codable {
    let _id : String?
    var category : String?
    var freeBottles : Int?
    let isRsvp : Bool?
    var isSection : Bool?
    let maxGuest : Int?
    let maxTicketPerUser : Int?
    var price : Int?
    var pricePerBottle : Int?
    var quantity : Int?
    let remaining : Int?
    var currentQuantity:Int?
  
}

struct performanceSlotDetails : Decodable {
    let _id : String?
    let isBooked : Bool?
    let timeStamp : String?
    let eventId : String?
    let start : String?
    let end : String?
    let __v : Int?
}

