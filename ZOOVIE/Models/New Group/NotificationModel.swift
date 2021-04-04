//
//  NotificationModel.swift
//  ZOOVIE
//
//  Created by abc on 06/06/20.
//  Copyright © 2020 Zoovie. All rights reserved.
//

import UIKit

class NotificationModel: Codable {
    var message:String?
    var statusCode:Int?
    var data: NotificationData?
}

class NotificationData: Codable {
    var notifications:[NotificationMessages]?
    var messages:[NotificationMessages]?
    var tickets:[NotificationTickets]?
}
class NotificationMessages: Codable{
    var adminNotification: Bool
    var createdAt: String
    var insertDate:String?
    var message:String?
    var receiverId:String?
    var senderId:String?
    var title: String?
    var type: Int
}
class NotificationTickets: Codable{
    var _id: String
    var category: String
    var price: Int
    var quantity: Int
}

