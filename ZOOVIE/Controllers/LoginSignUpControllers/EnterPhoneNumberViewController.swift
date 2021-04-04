//
//  EnterPhoneNumberViewController.swift
//  ZOOVIE
//
//  Created by abc on 30/05/20.
//  Copyright © 2020 Zoovie. All rights reserved.
//

import UIKit
import FlagPhoneNumber

class EnterPhoneNumberViewController: UIViewController {

    @IBOutlet weak var txtUserName: TextField!
    @IBOutlet weak var phoneTextField: FPNTextField!
    
    var dialCode = "+1"
    var email = ""
    var first_name = ""
    var last_name = ""
    var login_type = ""
    var social_id = ""
    var type = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        configView()
    }
    func configView(){
        phoneTextField.delegate = self
        if login_type == "forgot_password"{
            self.txtUserName.isHidden = true
            self.txtUserName.text = "username"
            self.type = "FP"
        }
    }
    @IBAction func actionClose(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func actionNext(_ sender: Any) {
        if AppManager.sharedInstance.range(textField: phoneTextField).count == 0{
            self.showAlert(alertMessage: Constants.AlertMessages.USER_PHONE)
        }else if AppManager.sharedInstance.range(textField: txtUserName).count == 0{
            self.showAlert(alertMessage: Constants.AlertMessages.USER_NAME)
        }else{
            self.showLoading()
            let phone_number = "\(self.dialCode)\(AppManager.sharedInstance.range(textField: self.phoneTextField).replacingOccurrences(of: " ", with: ""))"
            ApiHandler.call(apiName: Constant.API.CREATE_OTP, params: ["mobile": "\(dialCode)\(AppManager.sharedInstance.range(textField: phoneTextField))", "type": self.type], httpMethod: .POST) { (isSucceeded, response, data) in
                DispatchQueue.main.async {
                    self.hideLoading()
                    print(isSucceeded)
                    if isSucceeded == true {
                        print(response)
                        let vc = self.storyboard?.instantiateViewController(identifier: "OtpViewController") as! OtpViewController
                        vc.type = self.type //FP, UR
                        switch self.login_type {
                        case "forgot_password":
                            vc.fromScreen = self.login_type
                            vc.userDict = ["phone": phone_number.replacingOccurrences(of: "-", with: "")]
                            self.navigationController?.pushViewController(vc, animated: true)
                            break
                        default:
                            
                            vc.fromScreen = self.login_type
                             vc.userDict = ["email": self.email, "first_name": self.first_name, "last_name": self.last_name, "user_name": AppManager.sharedInstance.range(textField: self.txtUserName), "password": "12345678", "phone": phone_number.replacingOccurrences(of: "-", with: ""), "user_type": self.login_type, "social_id": self.social_id]
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                       
                    } else {
                        if let message = response["message"] as? String {
                            self.showAlert(alertMessage: message)
                        }
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
extension EnterPhoneNumberViewController : UITextFieldDelegate, FPNTextFieldDelegate {
    func fpnDisplayCountryList() {
        
    }
    
    /// The place to present/push the listController if you choosen displayMode = .list
   

    /// Lets you know when a country is selected
    func fpnDidSelectCountry(name: String, dialCode: String, code: String) {
       print(name, dialCode, code) // Output "France", "+33", "FR"
        self.dialCode = dialCode
    }

    /// Lets you know when the phone number is valid or not. Once a phone number is valid, you can get it in severals formats (E164, International, National, RFC3966)
    func fpnDidValidatePhoneNumber(textField: FPNTextField, isValid: Bool) {
       if isValid {
          // Do something...
                 // Output "tel:+33-6-00-00-00-01"
          print(textField.getRawPhoneNumber())                              // Output "600000001"
       } else {
          // Do something...
       }
    }
}
