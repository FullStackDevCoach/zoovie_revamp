//
//  SignUpViewController.swift
//  ZOOVIE
//
//  Created by abc on 14/05/20.
//  Copyright © 2020 Zoovie. All rights reserved.
//

import UIKit
import FlagPhoneNumber

class SignUpViewController: UIViewController {

    @IBOutlet weak var phoneTextField: FPNTextField!
    @IBOutlet weak var txtFname: TextField!
    @IBOutlet weak var txtLname: TextField!
    @IBOutlet weak var txtUsername: TextField!
    @IBOutlet weak var txtEmail: TextField!
    @IBOutlet weak var txtPassword: TextField!
  
    var dialCode = "+1"
    var login_type = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        configView()
    }
    func configView(){
        phoneTextField.delegate = self
    }
    @IBAction func actionToLogin(_ sender: Any) {
        actionDismiss()
    }
    @IBAction func actionClose(_ sender: Any) {
        actionDismiss()
    }
    func actionDismiss(){
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func actionSignUp(_ sender: Any) {
        if AppManager.sharedInstance.range(textField: txtFname).count == 0{
            self.showAlert(alertMessage: Constants.AlertMessages.USER_FIRST_NAME)
        }else if AppManager.sharedInstance.range(textField: txtLname).count == 0{
            self.showAlert(alertMessage: Constants.AlertMessages.USER_LAST_NAME)
        }else if AppManager.sharedInstance.range(textField: txtUsername).count == 0{
            self.showAlert(alertMessage: Constants.AlertMessages.USER_NAME)
        }else if AppManager.sharedInstance.range(textField: txtEmail).count == 0{
            self.showAlert(alertMessage: Constants.AlertMessages.USER_EMAIL)
        }else if AppManager.sharedInstance.range(textField: phoneTextField).count == 0{
            self.showAlert(alertMessage: Constants.AlertMessages.USER_PHONE)
        }else if AppManager.sharedInstance.range(textField: txtPassword).count == 0{
            self.showAlert(alertMessage: Constants.AlertMessages.USER_PASSWORD)
        }else if !AppManager.sharedInstance.isValidEmail(testStr: txtEmail.text!){
            self.showAlert(alertMessage: Constants.AlertMessages.VALID_EMAIL)
        }else if AppManager.sharedInstance.range(textField: txtPassword).count < 8{
            self.showAlert(alertMessage: Constants.AlertMessages.CHECK_PASSWORD)
        }else{
            
            self.showLoading()
            let phone_number = "\(self.dialCode)\(AppManager.sharedInstance.range(textField: self.phoneTextField).replacingOccurrences(of: " ", with: ""))"
            ApiHandler.call(apiName: Constant.API.CREATE_OTP, params: ["mobile": "\(dialCode)\(AppManager.sharedInstance.range(textField: phoneTextField))", "type": "UR"], httpMethod: .POST) { (isSucceeded, response, data) in
                DispatchQueue.main.async {
                    self.hideLoading()
                    print(isSucceeded)
                    if isSucceeded == true {
                        print(response)
                       let vc = self.storyboard?.instantiateViewController(identifier: "OtpViewController") as! OtpViewController
                        vc.userDict = ["email": AppManager.sharedInstance.range(textField: self.txtEmail), "first_name": AppManager.sharedInstance.range(textField: self.txtFname), "last_name": AppManager.sharedInstance.range(textField: self.txtLname), "user_name": AppManager.sharedInstance.range(textField: self.txtUsername), "password": AppManager.sharedInstance.range(textField: self.txtPassword), "phone": phone_number.replacingOccurrences(of: "-", with: "")]
                        vc.fromScreen = "signup"
                        vc.type = "UR"
                       self.navigationController?.pushViewController(vc, animated: true)
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
extension SignUpViewController : UITextFieldDelegate, FPNTextFieldDelegate {
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
