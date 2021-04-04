//
//  APIConstant.swift
//  ZOOVIE
//
//  Created by abc on 26/05/20.
//  Copyright © 2020 Zoovie. All rights reserved.
//

import UIKit

struct APIKey {
    
    static let data = "data"
    static let error = "error"
    static let authorization = "Authorization"
    static let contentType = "Content-Type"
    static let contentTypeJson = "application/json"
    static let accept = "Accept"
    static let authToken = "auth_token"
    static let id = "id"
    static let email = "email"
    static let bio = "bio"
    static let firstName = "firstName"
    static let lastName = "lastName"
    static let userName = "userName"
    static let userId = "userId"
    static let password = "password"
    static let lng = "lng"
    static let lat = "lat"
    static let deviceToken = "deviceToken"
    static let address =  "address"
    static let version = "version"
    static let deviceType = "deviceType"
    static let phoneNo =  "phoneNo"
    static let otpToken =  "otpToken"
    static let otp =  "otp"
    static let mobile = "mobile"
    static let newPassword = "newPassword"
    static let type = "type"
    static let user_type = "user_type"
    static let facebookId = "facebookId"
    static let appleId = "appleId"
    static let status = "status"
    static let eventId = "eventId"
    static let isLike = "isLike"
    static let image = "image"
    static let original = "original"
    static let thumbnail = "thumbnail"
}

struct Constant {
    
    struct WebUrl {
        static let urlCancelRoomRules = "https://www.google.com/en/privacy_policy"
        static let urlTicketTerm = "https://google.com/en/developer_agreement"
    }
    
    struct API {
        static let timeout = 90.0
        static let BASE_DOMAIN =  "https://zoovieapp.herokuapp.com/api/"
        
        //Customer Account
        static let LOGIN = "auth/user/login"
        static let SIGNUP = "users"
        static let SOCIAL_LOGIN = "auth/social/login"
        static let CREATE_OTP = "otp/create"
        static let VERIFY_OTP = "otp/verify"
        static let MY_PROFILE = "users/userDetails"
        static let LOGOUT = "logout"
        static let FORGOT_PASSWORD = "auth/password/reset/mobile"
        static let CLUBS = "events"
        static let GET_CITIES = "cities"
        static let CONNECT = "connections"
        static let LIKE_EVENT = "events/like"
        static let NOTIFICATION = "notifications"
        static let GET_ONLINE_EVENTS = "events/onlineEvents"
        static let FILE_UPLOAD = "s3upload/image-upload"
        static let STORIES_UPLOAD = "stories"
        static let EDIT_PROFILE = "users"
        static let EVENT_BOOKING = "bookings"
        
        static func othersProfile(id: String) -> String {
            return "users/userById?userId=\(id)"
        }
        static func editProfile(id: Int) -> String {
            return "customer/profile/\(id)"
        }
        static func events(id: String) -> String {
            return "events?eventId=\(id)"
        }
        static func clubs(city: String) -> String {
            return "clubs/homepage?city=\(city)"
        }
        static func clubDetails(id: String) -> String {
            return "events?clubId=\(id)"
        }
    }
    
}
struct ERROR_MESSAGE {
    static let NO_CAMERA_SUPPORT = "This device does not support camera"
    static let NO_GALLERY_SUPPORT = "Photo library not found in this device."
    static let REJECTED_CAMERA_SUPPORT = "Need permission to open camera"
    static let REJECTED_GALLERY_ACCESS = "Need permission to open Gallery"
    static let SOMETHING_WRONG = "Something went wrong. Please try again."
    static let NO_INTERNET_CONNECTION = "Unable to connect with the server. Check your internet connection and try again."
    static let SERVER_NOT_RESPONDING = "Something went wrong while connecting to server!"
    static let INVALID_ACCESS_TOKEN = "Invalid Access Token"
    static let ALL_FIELDS_MANDATORY = "All Fields Mandatory"
    static let CALLING_NOT_AVAILABLE = "Calling facility not available on this device."
}
struct AlertMessage {
    static let INVALID_ACCESS_TOKEN = "Invalid Access Token"
    static let SERVER_NOT_RESPONDING = "Something went wrong while connecting to server!"
    static let NO_INTERNET_CONNECTION = "Unable to connect with the server. Check your internet connection and try again."
    static let pleaseEnter = "Please enter "
    static let invalidEmailId = "Please enter valid email id."
    static let enterEmailId = "Please enter phone number."
    static let invalidPassword = "Please enter correct password."
    static let invalidPhoneNumber = "Please enter valid phone."
    static let invalidPasswordLength = "Password must contain atleast 6 characters"
    static let logoutAlert = "Are you sure you want to logout?"
    static let imageWarning = "The image we have showed above is for reference purpose. Actual car could be slightly different."
    static let emptyMessage = " can not be empty."
    static let bookingCreated = "Booking created successfully"
    static let passwordMismatch = "New password and confirm password does not match."
    static let passwordChangedSuccessfully = "Password changed successfully."
    static let pleaseEnterValid = "Please enter valid "
    static let transactionSuccessful = "Your transaction was successful"
    static let PROFILE_SAVED = "Profile has been saved successfully"
}
