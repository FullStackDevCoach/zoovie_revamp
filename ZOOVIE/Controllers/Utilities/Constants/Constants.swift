//
//  Constants.swift
//  ZOOVIE
//
//  Created by abc on 13/05/20.
//  Copyright © 2020 Zoovie. All rights reserved.
//


import UIKit
import MapKit

class Constants {

    
    struct Screen {
        static let window        = UIApplication.shared.windows
        static let width         = UIScreen.main.bounds.width
        static let height        = UIScreen.main.bounds.height
    }
    struct AlertMessages{
        /////////////////////////////////////////
        //MARK: - For Alert Message
        static let USER_FIRST_NAME = "Please enter first name"
        static let USER_LAST_NAME = "Please enter last name"
        static let USER_NAME = "Please enter username"
        static let USER_EMAIL = "Please enter email"
        static let USER_PHONE = "Please enter phone number"
        static let USER_PASSWORD = "Please enter password"
        static let VALID_EMAIL = "Please enter valid email"
        static let CHECK_PASSWORD = "Password must be atleast 8 characters long"
        static let ENTER_OTP = "Please enter otp"
        static let USER_BIO = "Please enter bio"
    }
    struct Variables{
        //MARK: - CONSTANT VARIABLES
        static let kAlertTitle  = "ZOOVIE"
        static let kLanguage = "language"
        static let kUserId = "user_id"
        static let kUserEmail = "user_email"
        static let kUserName = "user_name"
        static let kFirstName = "first_name"
        static let kLastName = "last_name"
        static let kUserImage = "user_image"
        static let kUserImageThumb = "user_image_thumb"
        static let kUserStatus = "user_status"
        static let kUserBio = "user_bio"
        static let kUserConn = "user_conn"
        static let kDeviceToken = "DeviceToken"
        static let kIsLogin = "isLogin"
        static let kAuthToken = "authentication_token"
        static let kPasswordMaxLength = 20

    }
    struct Colors{
        //MARK: - COLORS
        static let CLEAR_COLOR = UIColor.clear
        static let BLACK_COLOR = UIColor.black
        static let WHITE_COLOR = UIColor.white
        static let LIGHTGRAY_COLOR = UIColor.lightGray
        static let DARKGRAY_COLOR = UIColor.darkGray
        static let GRAY_COLOR = UIColor.gray
        
        static let LIGHT_SEPRATOR_COLOR = UIColor.init(hexString: "F5F9FC")
        static let APP_COLOR = UIColor.init(hexString: "D92D33")
        static let LIGHT_GRAY_COLOR = UIColor.init(hexString: "E9E9E9")
        static let APP_GREEN_COLOR = UIColor.init(hexString: "7BB384")
        static let CHART_MAN_COLOR = UIColor.init(hexString: "686868")
        static let CHART_WOMAN_COLOR = UIColor.init(hexString: "a6ccac")
        static let BLUE_COLOR = UIColor.init(hexString: "6BA671")
        
        
    }
    
    struct AppFont{
        static let kFontRegular = "Poppins-Regular"
        static let kFontBold = "Poppins-Bold"
        static let kFontMedium = "Poppins-Medium"
        static let kFontSemibold = "Poppins-Semibold"
    }
    struct DateFormats{
        static let kEventDateApi = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        static let kEventDate = "dd MMM"
        static let kEventDetailDate = "EEEE, MMM dd, hh:mm a"
    }
}

enum Font {
    enum AppFont: String {
        case bold = "Bold"
        case semiBold = "Semibold"
        case medium = "Medium"
        case light = "Light"
        case regular = "Regular"
        
        func with(size: CGFloat) -> UIFont {
            return UIFont(name: "Poppins-\(rawValue)", size: size)!
        }
    }
}


