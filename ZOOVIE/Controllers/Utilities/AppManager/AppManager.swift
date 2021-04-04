//
//  AppManager.swift
//  ZOOVIE
//
//  Created by abc on 28/05/20.
//  Copyright © 2020 Zoovie. All rights reserved.
//

import UIKit
import Kingfisher

class AppManager: NSObject {
    //MARK: App Manager Shared Instance
    class var sharedInstance:AppManager {
        struct Singleton {
            static let instance = AppManager()
        }
        return Singleton.instance
    }
 
    class func getVersion() -> String {
        guard let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
            return "1.0"
        }
        return version
    }
    
    class func getOSInfo()->String {
        let os = ProcessInfo().operatingSystemVersion
        return String(os.majorVersion) + "." + String(os.minorVersion) + "." + String(os.patchVersion)
    }
    
  
    //MARK: Validation
    func isValidEmail(testStr:String) -> Bool {
        print("validate emilId: \(testStr)")
        let emailRegEx = "(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: testStr)
        return result
    }
    func isValidpassword(mypassword : String) -> Bool{
        let passwordRegEx = "(?:(?:(?=.*?[0-9])(?=.*?[-!@#$%&*ˆ+=_])|(?:(?=.*?[0-9])|(?=.*?[A-Z])|(?=.*?[-!@#$%&*ˆ+=_])))|(?=.*?[a-z])(?=.*?[0-9])(?=.*?[-!@#$%&*ˆ+=_]))[A-Za-z0-9-!@#$%&*ˆ+=_]{6,15}"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
        return passwordTest.evaluate(with: mypassword)
    }
    func validatePhoneNumber(value: String) -> Bool {
        let PHONE_REGEX = "^\\d{3}-\\d{3}-\\d{4}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: value)
        return result
    }
    func range(textField: UITextField) -> String{
        return textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
    }
    func range(text: String) -> String{
        return text.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    func getUserSeparateName(fullName: String) -> (String, String ,String){
        var firstName = ""
        var lastName = ""
        var middleName = ""
        var components = fullName.components(separatedBy: " ")
        if components.count > 0 {
        firstName = components.removeFirst()
        if components.count > 0 {
            lastName = components.removeLast()
        }
       middleName = components.joined(separator: " ")
        debugPrint(firstName)
        debugPrint(lastName)
        }
        return (firstName, middleName, lastName)
    }
    func showTopAlert(alertText : String = "Alert", alertMessage : String) {
       var topWindow: UIWindow? = UIWindow(frame: UIScreen.main.bounds)
        topWindow?.rootViewController = UIViewController()
        topWindow?.windowLevel = UIWindow.Level.alert + 1

        let alert = UIAlertController(title: alertText, message: alertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel) { _ in
            // continue your work

            // important to hide the window after work completed.
            // this also keeps a reference to the window until the action is invoked.
            topWindow?.isHidden = true // if you want to hide the topwindow then use this
            topWindow = nil // if you want to hide the topwindow then use this
         })

        topWindow?.makeKeyAndVisible()
        topWindow?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    //MARK: Logged in User Info
    
    class func isLogin() -> Bool {
        return UserDefaults.standard.bool(forKey: Constants.Variables.kIsLogin) ? true:false
    }
    //   MARK: Set User Data
     
      var userToken: String? {
         get {
            let  userToken = UserDefaults.standard.object(forKey: Constants.Variables.kAuthToken)
              return userToken as? String
         }
         set {
          if let newValue = newValue {
             UserDefaults.standard.set(newValue, forKey: Constants.Variables.kAuthToken)
          }
         }
     }
    var customerId: String? {
        get {
            if let customerId = UserDefaults.standard.object(forKey: Constants.Variables.kUserId) as? String {
                return customerId
            }else{
                return ""
            }
        }
        set {
         if let newValue = newValue {
            UserDefaults.standard.set(newValue, forKey: Constants.Variables.kUserId)
         }
        }
    }
  
     var userName: String? {
         get {
             if let userName = UserDefaults.standard.object(forKey: Constants.Variables.kUserName) as? String {
                 return userName
             }else{
                 return ""
             }
         }
         set {
          if let newValue = newValue {
             UserDefaults.standard.set(newValue, forKey: Constants.Variables.kUserName)
          }
         }
     }
    var firstName: String? {
        get {
            if let firstName = UserDefaults.standard.object(forKey: Constants.Variables.kFirstName) as? String {
                return firstName
            }else{
                return ""
            }
        }
        set {
         if let newValue = newValue {
            UserDefaults.standard.set(newValue, forKey: Constants.Variables.kFirstName)
         }
        }
    }
    var lastName: String? {
        get {
            if let lastName = UserDefaults.standard.object(forKey: Constants.Variables.kLastName) as? String {
                return lastName
            }else{
                return ""
            }
        }
        set {
         if let newValue = newValue {
            UserDefaults.standard.set(newValue, forKey: Constants.Variables.kLastName)
         }
        }
    }
      var userEmail: String? {
            get {
             if let userEmail = UserDefaults.standard.object(forKey: Constants.Variables.kUserEmail) as? String {
                 return userEmail
             }else{
                 return ""
             }
            }
            set {
             if let newValue = newValue {
                UserDefaults.standard.set(newValue, forKey: Constants.Variables.kUserEmail)
             }
            }
        }
     var userPhoto: String? {
         get {
             if let userPhoto = UserDefaults.standard.object(forKey: Constants.Variables.kUserImage) as? String {
                 return userPhoto
             }else{
                 return ""
             }
         }
         set {
          if let newValue = newValue {
             UserDefaults.standard.set(newValue, forKey: Constants.Variables.kUserImage)
          }
         }
     }
    var userPhotoThumb: String? {
        get {
            if let userPhotoThumb = UserDefaults.standard.object(forKey: Constants.Variables.kUserImageThumb) as? String {
                return userPhotoThumb
            }else{
                return ""
            }
        }
        set {
         if let newValue = newValue {
            UserDefaults.standard.set(newValue, forKey: Constants.Variables.kUserImageThumb)
         }
        }
    }
    var userBio: String? {
        get {
            if let userBio = UserDefaults.standard.object(forKey: Constants.Variables.kUserBio) as? String {
                return userBio
            }else{
                return "I almost wrote a cool bio ..."
            }
        }
        set {
         if let newValue = newValue {
            UserDefaults.standard.set(newValue, forKey: Constants.Variables.kUserBio)
         }
        }
    }
    var userStatus: String? {
           get {
               if let userStatus = UserDefaults.standard.object(forKey: Constants.Variables.kUserStatus) as? String {
                   return userStatus
               }else{
                   return ""
               }
           }
           set {
            if let newValue = newValue {
               UserDefaults.standard.set(newValue, forKey: Constants.Variables.kUserStatus)
            }
           }
       }
    var userConnections: Int? {
        get {
            if let userConnections = UserDefaults.standard.object(forKey: Constants.Variables.kUserConn) as? Int {
                return userConnections
            }else{
                return 0
            }
        }
        set {
         if let newValue = newValue {
            UserDefaults.standard.set(newValue, forKey: Constants.Variables.kUserConn)
         }
        }
    }
     var deviceToken: String? {
         get {
            if let deviceToken = UserDefaults.standard.object(forKey: Constants.Variables.kDeviceToken) as? String {
                return deviceToken
            }else{
                return "12345"
            }
        }
         set {
          if let newValue = newValue {
             UserDefaults.standard.set(newValue, forKey: Constants.Variables.kDeviceToken)
          }
         }
     }
    func convertDateFormaterDynamic(_ date: String, fromFormat: String, toFormat: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = fromFormat
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = toFormat
        return  dateFormatter.string(from: date!)
    }
    func shareAppUrl(view: UIViewController){
            let link = "https://itunes.apple.com/us/app/zoovie-world/id1459877116?ls=1&mt=8"
            let linkUrl = URL.init(string: link)
            let items = ["Please download this app.", linkUrl!] as [Any]
            let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
            view.present(ac, animated: true)
    }
    //MARK: - image Resize
    func resizeImage(image : UIImage , targetSize : CGSize) -> UIImage{
        let originalSize:CGSize =  image.size
        
        let widthRatio :CGFloat = targetSize.width/originalSize.width
        let heightRatio :CGFloat = targetSize.height/originalSize.height
        
        var newSize : CGSize!
        if widthRatio > heightRatio {
            newSize =  CGSize(width : originalSize.width*heightRatio ,  height : originalSize.height * heightRatio)
        }
        else{
            newSize = CGSize(width : originalSize.width * widthRatio , height : originalSize.height*widthRatio)
        }
        
        // preparing rect for new image
        
        let rect:CGRect =  CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        UIGraphicsBeginImageContextWithOptions(newSize, false, UIScreen.main.scale)
        image .draw(in: rect)
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    //MARK: - error message -

    class func getErrorMessage(_ error : NSError) -> String {
        var errorMessage: NSString = NSString()
        switch error.code {
        case -998:
            errorMessage = "Unknow Error";
            break;
        case -1000:
            errorMessage = "Bad URL request";
            break;
        case -1001:
            errorMessage = "The request time out";
            break;
        case -1002:
            errorMessage = "Unsupported URL";
            break;
        case -1003:
            errorMessage = "The host could not be found";
            break;
        case -1004:
            errorMessage = "The host could not be connect, Please try after some time";
            break;
        case -1005:
            errorMessage = "The network connection lost Please try agian";
            break;
        case -1009:
            errorMessage = "The internet connection appear to be offline" ;
            break;
        case -1103:
            errorMessage = "Data length exceed to maximum defined data";
            break;
        case -1100:
            errorMessage = "File does not exist";
            break;
        case -1013:
            errorMessage = "User authentication required";
            break;
        case -2102:
            errorMessage = "The request time out";
            break;
        default:
            errorMessage = "Server Error";
            break;
        }
        return errorMessage as String
    }
 
}
extension UIImageView {
    func setImage(with urlString: String){
        guard let url = URL.init(string: urlString) else {
            return
        }
        let resource = ImageResource(downloadURL: url, cacheKey: urlString)
        var kf = self.kf
        kf.indicatorType = .activity
        self.kf.setImage(with: resource)
    }
}
extension String {
    func getDate() -> String {
        let interval : TimeInterval = Double(self)!
        let date = Date(timeIntervalSince1970: interval)
        let df = DateFormatter()
        df.dateFormat = Constants.DateFormats.kEventDetailDate
        let dateStr = df.string(from: date)
        return dateStr
    }
}
