//
//  SplashViewController.swift
//  ZOOVIE
//
//  Created by abc on 16/05/20.
//  Copyright © 2020 Zoovie. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import AuthenticationServices

class SplashViewController: UIViewController {

    @IBOutlet weak var appleSignInView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpSignInAppleButton()
        print(AppManager.sharedInstance.userToken)
    }
    
    @IBAction func actionFacebook(_ sender: Any) {
         // Login with facebook
         let fbLoginManager  = LoginManager()
         fbLoginManager.logOut()
         fbLoginManager.logIn(permissions: [ "public_profile","email"], from: self) { (result, error) in
             if (error == nil){
                 let fbloginresult : LoginManagerLoginResult = result!
                 if fbloginresult.grantedPermissions != nil {
                     if fbloginresult.token != nil{
                         print(fbloginresult.token!.tokenString)
                         print(AccessToken.current?.tokenString ?? "")
                         self.getFBUserData()
                     }
                 }
             }
         }
    }
     //MARK: - Get FBUser Data -
        func getFBUserData(){
            if((AccessToken.current) != nil) {
                GraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email ,location"]).start(completionHandler: { (connection, result, error) -> Void in
                    if (error == nil){
                        let dict_FBData = result as? [String : AnyObject]
                        print(dict_FBData ?? [:])
                        let parameters =  [APIKey.firstName: dict_FBData?["first_name"] as! String, APIKey.lastName: dict_FBData?["last_name"] as! String, APIKey.email: dict_FBData?["email"] as! String, APIKey.lat: "0", APIKey.lng: "0", APIKey.deviceToken: AppManager.sharedInstance.deviceToken ?? "12345", APIKey.address: "Address", APIKey.version: "1.0", APIKey.deviceType: "IOS", APIKey.user_type: "facebook", APIKey.facebookId: dict_FBData?["id"] as! String ]
                        self.apiSocial(parameters: parameters, login_type: "facebook")
                    }
                })
            }
        }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    func apiSocial(parameters: [String: Any], login_type: String){
        self.showLoading()
        ApiHandler.call(apiName: Constant.API.SOCIAL_LOGIN, params: parameters, httpMethod: .POST) { (isSucceeded, response, data) in
            DispatchQueue.main.async {
                
                print(isSucceeded)
                if isSucceeded == true {
                    print(response)
                    guard let data = data else { return }
                                        do {
                     let decoder = JSONDecoder()
                     let response = try decoder.decode(LoginModel.self, from: data)
                    self.hideLoading()
                     if let isUser = response.data?.isNewUser {
                        if isUser == false{
                            //Already have account
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
                        }else{
                            //Account does not exists
                            let vc = self.storyboard?.instantiateViewController(identifier: "EnterPhoneNumberViewController") as! EnterPhoneNumberViewController
                            
                            vc.login_type = login_type
                            vc.email = parameters["email"] as! String
                            vc.first_name = parameters["firstName"] as! String
                            vc.last_name = parameters["lastName"] as! String
                            if login_type == "facebook"{
                                vc.social_id = parameters["facebookId"] as! String
                            }else{
                                vc.social_id = parameters["appleId"] as! String
                            }
                            
                            vc.type = "UR"
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                     }
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
extension SplashViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    func setUpSignInAppleButton() {
        if #available(iOS 13.0, *) {
            let authorizationButton = ASAuthorizationAppleIDButton(type: .signIn, style: .white)
            authorizationButton.layer.cornerRadius = 22
            authorizationButton.addTarget(self, action: #selector(handleAppleIdRequest), for: .touchUpInside)
            authorizationButton.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width-50, height: 45)
            appleSignInView.addSubview(authorizationButton)
        } else {
            // Fallback on earlier versions
        }
    }
    @objc func handleAppleIdRequest() {
        if #available(iOS 13.0, *) {
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.presentationContextProvider = self
            authorizationController.performRequests()
        } else {
            // Fallback on earlier versions
        }
    }
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as?  ASAuthorizationAppleIDCredential {
            
            if let identityTokenData = appleIDCredential.identityToken,
                let identityTokenString = String(data: identityTokenData, encoding: .utf8) {
                
                KeychainItem.currentUserIdentifier = appleIDCredential.user
                
                print("User Id - \(appleIDCredential.user)")
                print("User Name - \(appleIDCredential.fullName?.description ?? "N/A")")
                print("User Email - \(appleIDCredential.email ?? "N/A")")
                print("Real User Status - \(appleIDCredential.realUserStatus.rawValue)")
                
                if let retrievedID: String = KeychainItem.currentUserIdentifier{
                    print(retrievedID)
                }else{
                    KeychainItem.currentUserIdentifier = appleIDCredential.user
                }
                if let _: String = KeychainItem.currentUserLastName{
                }else{
                    KeychainItem.currentUserLastName = appleIDCredential.fullName?.familyName
                }
                
                if let _: String = KeychainItem.currentUserFirstName{
                }else{
                    KeychainItem.currentUserFirstName = appleIDCredential.fullName?.givenName
                }
                if let _: String = KeychainItem.currentUserEmail{
                }else{
                    KeychainItem.currentUserEmail = appleIDCredential.email
                }
                print("Identity Token \(identityTokenString)")
                let parameters =  [APIKey.firstName: KeychainItem.currentUserFirstName ?? "", APIKey.lastName: KeychainItem.currentUserLastName ?? "", APIKey.email: KeychainItem.currentUserEmail ?? "", APIKey.lat: "0", APIKey.lng: "0", APIKey.deviceToken: AppManager.sharedInstance.deviceToken ?? "12345", APIKey.address: "Address", APIKey.version: "1.0", APIKey.deviceType: "IOS", APIKey.user_type: "apple", APIKey.appleId: KeychainItem.currentUserIdentifier ?? ""]
                self.apiSocial(parameters: parameters, login_type: "apple")
            }
        }
    }
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print(error.localizedDescription)
    }
    @available(iOS 13.0, *)
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
