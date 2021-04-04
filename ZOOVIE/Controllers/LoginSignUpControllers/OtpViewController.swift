//
//  OtpViewController.swift
//  ZOOVIE
//
//  Created by abc on 16/05/20.
//  Copyright © 2020 Zoovie. All rights reserved.
//

import UIKit
import OTPFieldView

class OtpViewController: UIViewController{

    @IBOutlet weak var otpTextFieldView: OTPFieldView!
    
    
    //MARK:- Variables
    var userDict = [String: String]()
    var code = String()
    var fromScreen = String()
    var type = "UR"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.setupOtpView()
    }
    
    private func setupOtpView(){
        self.otpTextFieldView.fieldsCount = 4
        self.otpTextFieldView.fieldBorderWidth = 2
        self.otpTextFieldView.defaultBorderColor = UIColor.black
        self.otpTextFieldView.filledBorderColor = UIColor.green
        self.otpTextFieldView.cursorColor = UIColor.red
        self.otpTextFieldView.displayType = .underlinedBottom
        self.otpTextFieldView.fieldSize = 40
        self.otpTextFieldView.separatorSpace = 8
        self.otpTextFieldView.shouldAllowIntermediateEditing = false
        self.otpTextFieldView.delegate = self
        self.otpTextFieldView.initializeUI()
    }

    @IBAction func actionToHome(_ sender: Any) {
        //AppDelegate.sharedDelegate.goToHomeVC()
        if AppManager.sharedInstance.range(text: code).count == 0{
            self.showAlert(alertMessage: Constants.AlertMessages.ENTER_OTP)
        }else{
            self.apiVerifyOTP()
        }
    }
    
    @IBAction func actionResentOtp(_ sender: Any) {
        self.showLoading()
        ApiHandler.call(apiName: Constant.API.CREATE_OTP, params: [APIKey.mobile: (userDict["phone"] ?? "").replacingOccurrences(of: " ", with: ""), APIKey.type: self.type], httpMethod: .POST) { (isSucceeded, response, data) in
        DispatchQueue.main.async {
            self.hideLoading()
            print(isSucceeded)
            if isSucceeded == true {
                print(response)
               if let message = response["data"] as? String {
                   self.showAlert(alertMessage: message)
               }
            } else {
                if let message = response["message"] as? String {
                    self.showAlert(alertMessage: message)
                }
            }
        }
    }
}
func apiVerifyOTP(){
    self.showLoading()
    print(["otp": code, "mobile": userDict["phone"] ?? "", "type": self.type])
    ApiHandler.call(apiName: Constant.API.VERIFY_OTP, params: ["otp": Int(code) ?? 0, "mobile": userDict["phone"] ?? "", "type": self.type], httpMethod: .POST) { (isSucceeded, response, data) in
        DispatchQueue.main.async {
            
            print(isSucceeded)
            if isSucceeded == true {
                print(response)
                if let data = response["data"] as? Dictionary<String, Any>{
                    if self.fromScreen == "forgot_password"{
                        let vc = self.storyboard?.instantiateViewController(identifier: "ForgotPasswordController") as! ForgotPasswordController
                        vc.otp = self.code
                        vc.phone = self.userDict["phone"] ?? ""
                        self.navigationController?.pushViewController(vc, animated: true)
                    }else{
                        //signup, facebook, apple
                        self.apiSignUp(token : data["token"] as? Int ?? 0 )
                    }
                    
                }
               
            } else {
                self.hideLoading()
                if let message = response["message"] as? String {
                    self.showAlert(alertMessage: message)
                }
            }
        }
    }
   }
    func apiSignUp(token: Int){
        
        var parameters = [String: Any]()
        var API_URL = Constant.API.SIGNUP
        switch fromScreen {
        case "facebook":
            API_URL = Constant.API.SOCIAL_LOGIN
            parameters =  [APIKey.firstName: userDict["first_name"] ?? "", APIKey.lastName: userDict["last_name"] ?? "", APIKey.userName: userDict["user_name"] ?? "", APIKey.email: userDict["email"] ?? "", APIKey.password: userDict["password"] ?? "", APIKey.lat: "0", APIKey.lng: "0", APIKey.deviceToken: AppManager.sharedInstance.deviceToken ?? "12345", APIKey.address: "Address", APIKey.version: "1.0", APIKey.deviceType: "IOS", APIKey.phoneNo: userDict["phone"] ?? "", APIKey.otpToken: token, APIKey.user_type: userDict["user_type"] ?? "", APIKey.facebookId: userDict["social_id"] ?? "" ]
            break
        case "signup":
             parameters =  [APIKey.firstName: userDict["first_name"] ?? "", APIKey.lastName: userDict["last_name"] ?? "", APIKey.userName: userDict["user_name"] ?? "", APIKey.email: userDict["email"] ?? "", APIKey.password: userDict["password"] ?? "", APIKey.lat: "0", APIKey.lng: "0", APIKey.deviceToken: AppManager.sharedInstance.deviceToken ?? "12345", APIKey.address: "Address", APIKey.version: "1.0", APIKey.deviceType: "IOS", APIKey.phoneNo: userDict["phone"] ?? "", APIKey.otpToken: token]
            break
        case "apple":
            API_URL = Constant.API.SOCIAL_LOGIN
            parameters =  [APIKey.firstName: userDict["first_name"] ?? "", APIKey.lastName: userDict["last_name"] ?? "", APIKey.userName: userDict["user_name"] ?? "", APIKey.email: userDict["email"] ?? "", APIKey.password: userDict["password"] ?? "", APIKey.lat: "0", APIKey.lng: "0", APIKey.deviceToken: AppManager.sharedInstance.deviceToken ?? "12345", APIKey.address: "Address", APIKey.version: "1.0", APIKey.deviceType: "IOS", APIKey.phoneNo: userDict["phone"] ?? "", APIKey.otpToken: token, APIKey.user_type: userDict["user_type"] ?? "", APIKey.appleId: userDict["social_id"] ?? "" ]
            break
        default:
            return
        }
    
    print(parameters)
    self.showLoading()
    ApiHandler.call(apiName: API_URL, params: parameters, httpMethod: .POST) { (isSucceeded, response, data) in
        DispatchQueue.main.async {
            
            print(isSucceeded)
            if isSucceeded == true {
                print(response)
                
                guard let data = data else { return }
                do {
                 let decoder = JSONDecoder()
                 let response = try decoder.decode(LoginModel.self, from: data)
                 if let accessToken = response.data?.accessToken {
                     AppManager.sharedInstance.userToken = accessToken
                 }
                 if let _id = response.data?._id {
                     AppManager.sharedInstance.customerId = _id
                 }
                 if let status = response.data?.status {
                     AppManager.sharedInstance.userStatus = status
                 }
                 if let userName = response.data?.userName {
                     AppManager.sharedInstance.userName = userName
                 }
                 if let firstName = response.data?.firstName {
                     AppManager.sharedInstance.firstName = firstName
                 }
                 if let lastName = response.data?.lastName {
                     AppManager.sharedInstance.lastName = lastName
                 }
                 if let userConnections = response.data?.totalConnections {
                     AppManager.sharedInstance.userConnections = userConnections
                 }
                                       
                AppDelegate.sharedDelegate.goToHomeVC()
                } catch let err {
                    print(err)
                }
            } else {
                self.hideLoading()
                if let message = response["message"] as? String {
                    self.showAlert(alertMessage: message)
                }
            }
        }
    }
    
   }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension OtpViewController : OTPFieldViewDelegate {
    func shouldBecomeFirstResponderForOTP(otpTextFieldIndex index: Int) -> Bool {
        return true
    }
    
    func enteredOTP(otp: String) {
        print(otp)
        code = otp
    }
    
    func hasEnteredAllOTP(hasEnteredAll: Bool) -> Bool {
        return true
    }
    
    
}
