//
//  LoginViewController.swift
//  ZOOVIE
//
//  Created by abc on 16/05/20.
//  Copyright © 2020 Zoovie. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    //MARK:- Outlets
    @IBOutlet weak var txtEmail: TextField!
    @IBOutlet weak var txtPassword: TextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //self.txtEmail.text = "mmm@gmail.com"
        //self.txtPassword.text = "12345678"
        self.configView()
    }
    func configView(){
        self.txtEmail.delegate = self
        self.txtPassword.delegate = self
    }
    @IBAction func actionClose(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func actionLogin(_ sender: Any) {
        if AppManager.sharedInstance.range(textField: txtEmail).count == 0{
            self.showAlert(alertMessage: Constants.AlertMessages.USER_EMAIL)
        }else if AppManager.sharedInstance.range(textField: txtPassword).count == 0{
            self.showAlert(alertMessage: Constants.AlertMessages.USER_PASSWORD)
        }else if !AppManager.sharedInstance.isValidEmail(testStr: txtEmail.text!){
            self.showAlert(alertMessage: Constants.AlertMessages.VALID_EMAIL)
        }else{
            self.apiLogin()
        }
    }
    func apiLogin(){
        self.showLoading()
        
        ApiHandler.call(apiName: Constant.API.LOGIN, params: [APIKey.version: "1.0", APIKey.email: AppManager.sharedInstance.range(textField: self.txtEmail), APIKey.password: AppManager.sharedInstance.range(textField: self.txtPassword), APIKey.deviceToken: AppManager.sharedInstance.deviceToken ?? "12345", "deviceType": "IOS"], httpMethod: .POST) { (isSucceeded, response, data) in
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
    @IBAction func actionForgotPassword(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(identifier: "EnterPhoneNumberViewController") as! EnterPhoneNumberViewController
        vc.login_type = "forgot_password"
        vc.type = "FP"
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
extension LoginViewController: UITextFieldDelegate{
    //MARK:- UITextfieldDelegate Methods
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.text = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
