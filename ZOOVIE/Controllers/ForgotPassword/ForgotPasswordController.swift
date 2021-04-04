//
//  ForgotPasswordController.swift
//  ZOOVIE
//
//  Created by abc on 31/05/20.
//  Copyright © 2020 Zoovie. All rights reserved.
//

import UIKit

class ForgotPasswordController: UIViewController {

    //MARK:- Variables
    var phone = String()
    var otp = String()
    
    //MARK:- Outlets
    @IBOutlet weak var txtNewPassword: TextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func actionSetPassword(_ sender: Any) {
        if AppManager.sharedInstance.range(textField: txtNewPassword).count == 0{
            self.showAlert(alertMessage: Constants.AlertMessages.USER_EMAIL)
        }else if AppManager.sharedInstance.range(textField: txtNewPassword).count < 8{
            self.showAlert(alertMessage: Constants.AlertMessages.CHECK_PASSWORD)
        }else{
            self.apiForgotPassword()
        }
    }
    func apiForgotPassword(){
        self.showLoading()
        ApiHandler.call(apiName: Constant.API.FORGOT_PASSWORD, params: [APIKey.mobile: self.phone, APIKey.newPassword: AppManager.sharedInstance.range(textField: txtNewPassword), APIKey.otp: self.otp], httpMethod: .POST) { (isSucceeded, response, data) in
            DispatchQueue.main.async {
                self.hideLoading()
                print(isSucceeded)
                if isSucceeded == true {
                    print(response)
                   if let message = response["data"] as? String {
                       self.backToLogin(message: message)
                   }
                } else {
                    if let message = response["message"] as? String {
                        self.showAlert(alertMessage: message)
                    }
                }
            }
        }
    }
    func backToLogin(message: String){
        let alert = UIAlertController(title: "", message: message,         preferredStyle: UIAlertController.Style.alert)
            
        alert.addAction(UIAlertAction(title: "Ok",
                                          style: UIAlertAction.Style.default,
                                       handler: {(_: UIAlertAction!) in
                                         var allViewControllers: [UIViewController]? = nil
         if let view = self.navigationController?.viewControllers {
                 allViewControllers = view
         }
         for aViewController in allViewControllers ?? [] {
             if (aViewController is LoginViewController) {
                 self.navigationController?.popToViewController(aViewController, animated: false)
             }
         }
         }))
        self.present(alert, animated: true, completion: nil)
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
