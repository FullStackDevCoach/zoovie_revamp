//
//  EditProfileController.swift
//  ZOOVIE
//
//  Created by abc on 07/06/20.
//  Copyright © 2020 Zoovie. All rights reserved.
//

import UIKit
import Firebase

class EditProfileController: UIViewController {

    //MARK:- Outlets
    @IBOutlet weak var firstNameField: FloatingTextField!
    @IBOutlet weak var lastNameField: FloatingTextField!
    //@IBOutlet weak var userNameField: FloatingTextField!
    @IBOutlet weak var emailField: FloatingTextField!
    @IBOutlet weak var bioField: FloatingTextField!
    @IBOutlet weak var userImage: UIImageView!
    
    //MARK:- Variables
    var selectedImageUrl = ""
    var selectedImageThumb = ""
    var imagePicker: ImagePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configView()
        self.setRightSwipeGesture()
    }
    func configView(){
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        
        self.firstNameField.text = AppManager.sharedInstance.firstName
        self.lastNameField.text = AppManager.sharedInstance.lastName
        self.emailField.text = AppManager.sharedInstance.userEmail
        //self.userNameField.text = AppManager.sharedInstance.userName
        if AppManager.sharedInstance.userBio == ""{
            self.bioField.text = "I almost wrote a cool bio ..."
        }else{
            self.bioField.text = AppManager.sharedInstance.userBio
        }
        if AppManager.sharedInstance.userPhoto != ""{
            if AppManager.sharedInstance.userPhoto?.contains("http") ?? false{
                self.userImage.setImage(with: AppManager.sharedInstance.userPhoto ?? "")
            }else{
                self.userImage.image = UIImage(named: "placeholder")
            }
            self.selectedImageUrl = AppManager.sharedInstance.userPhoto ?? ""
            self.selectedImageThumb = AppManager.sharedInstance.userPhotoThumb ?? ""
        }
    }
    
    @IBAction func actionChangePhoto(_ sender: UIButton) {
        self.imagePicker.present(from: sender)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationItem.title = "Edit Profile"
        let barButton:UIButton = UIButton(type: .custom)
        barButton.setTitle("SAVE", for: .normal)
        barButton.setTitleColor(Constants.Colors.APP_COLOR, for: .normal)
        barButton.titleLabel?.font = UIFont(name: Constants.AppFont.kFontMedium, size: 14)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: barButton)
        barButton.addTarget(self, action: #selector(saveData), for: .touchUpInside)
    }
    @objc func saveData() {
        self.view.endEditing(true)
        if AppManager.sharedInstance.range(textField: firstNameField).count == 0{
            self.showAlert(alertMessage: Constants.AlertMessages.USER_FIRST_NAME)
        }else if AppManager.sharedInstance.range(textField: lastNameField).count == 0{
            self.showAlert(alertMessage: Constants.AlertMessages.USER_LAST_NAME)
//        }else if AppManager.sharedInstance.range(textField: userNameField).count == 0{
//            self.showAlert(alertMessage: Constants.AlertMessages.USER_NAME)
        }else if AppManager.sharedInstance.range(textField: emailField).count == 0{
            self.showAlert(alertMessage: Constants.AlertMessages.USER_EMAIL)
        }else if AppManager.sharedInstance.range(textField: bioField).count == 0{
            self.showAlert(alertMessage: Constants.AlertMessages.USER_BIO)
        }else if !AppManager.sharedInstance.isValidEmail(testStr: emailField.text!){
            self.showAlert(alertMessage: Constants.AlertMessages.VALID_EMAIL)
        }else{
            var json = [String: Any]()
            json[APIKey.firstName] = self.firstNameField.text
            json[APIKey.lastName] = self.lastNameField.text
            json[APIKey.email] = self.emailField.text
            json[APIKey.bio] = self.bioField.text
            //json[APIKey.userName] = self.userNameField.text
            var jsonImage = [String: String]()
            if self.selectedImageUrl != ""{
                jsonImage[APIKey.original] = self.selectedImageUrl
                jsonImage[APIKey.thumbnail] = self.selectedImageThumb
                json[APIKey.image] = jsonImage
            }
            self.apiRequest(json: json)
        }
    }
    
    func resetData() {
        AppManager.sharedInstance.firstName = self.firstNameField.text
        AppManager.sharedInstance.lastName = self.lastNameField.text
        AppManager.sharedInstance.userEmail = self.emailField.text
        AppManager.sharedInstance.userBio = self.bioField.text
        AppManager.sharedInstance.userPhoto = self.selectedImageUrl
        AppManager.sharedInstance.userPhotoThumb = self.selectedImageThumb
    }
    
    func setRightSwipeGesture() {
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(backAction))
        rightSwipe.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(rightSwipe)
    }
    @objc func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
}
//MARK:- ImagePicker Delegate
extension EditProfileController: ImagePickerDelegate{
     func didSelect(image: UIImage?) {
        if image != nil{
             self.apiUploadImage(image: image!)
        }
    }
}
extension EditProfileController{
    func apiRequest(json: [String: Any]) {
        self.showLoading()
            print("json = ", json)
        ApiHandler.call(apiName: Constant.API.EDIT_PROFILE, params: json, httpMethod: .PUT) { (isSucceeded, response, data) in
                DispatchQueue.main.async {
                    self.hideLoading()
                    if isSucceeded == true {
                        print(response)
                        DispatchQueue.main.async {
                        self.resetData()
                        // Create the alert controller
                        let alertController = UIAlertController(title: "", message: "Profile has been updated.", preferredStyle: .alert)
                        
                        // Create the actions
                        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                            UIAlertAction in
                            self.actionBack()
                        }
                        // Add the actions
                        alertController.addAction(okAction)
                        // Present the controller
                        self.present(alertController, animated: true, completion: nil)
                        }
                    } else {
                        if let message = response["message"] as? String {
                            self.showAlert(alertMessage: message)
                        }
                    }
                }
                
            }
            
        }
    func apiUploadImage(image: UIImage){
        self.userImage.image = image
        self.uploadImage(imageArray: [image])
    }
    func uploadImage(imageArray:[UIImage]) {
        self.showLoading()
        ApiHandler.uploadImage(apiName: Constant.API.FILE_UPLOAD, imageArray: imageArray, imageKey: APIKey.image, params: [:]) { (isSucceeded, response, data) in
            DispatchQueue.main.async {
                self.hideLoading()
                if isSucceeded == true {
                    print(response)
                    guard let data = data else { return }
                    do {
                        let decoder = JSONDecoder()
                        let jsonResponse = try decoder.decode(ImageModel.self, from: data)
                        DispatchQueue.main.async {
                            guard let data = jsonResponse.data else {return}
                            self.selectedImageUrl = data.original ?? ""
                            self.selectedImageThumb = data.thumb ?? ""
                        }
                    } catch let err {
                        print(err)
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
