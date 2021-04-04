//
//  MyProfileController.swift
//  ZOOVIE
//
//  Created by abc on 12/05/20.
//  Copyright © 2020 Zoovie. All rights reserved.
//

import UIKit
import CarbonKit

class MyProfileController: UIViewController {

    //MARK:- Outlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!{
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.register(UINib(nibName: "ImageCollectionCell", bundle: nil), forCellWithReuseIdentifier: "ImageCollectionCell")
            
        }
        
    }
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var connectionLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var btnEdit: UIButton!
    
    //MARK:- Variables
    var userDetails : LoginModel?
    var imagePicker: ImagePicker!
    var imageData = ImageData()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        getProfile()
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
    }
    func setUserDetails(){
        userNameLabel.text = AppManager.sharedInstance.userName
        nameLabel.text = "\(AppManager.sharedInstance.firstName ?? "") \(AppManager.sharedInstance.lastName ?? "")"
        statusLabel.text = AppManager.sharedInstance.userStatus
        connectionLabel.text = "\(AppManager.sharedInstance.userConnections ?? 0) Connections"
        configureTabBar()
        
    }
    @IBAction func actionEdit(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(identifier: "EditProfileController") as! EditProfileController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.setUserDetails()
    }
}
extension MyProfileController: UICollectionViewDataSource, UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (self.userDetails?.data?.stories?.count ?? 0)+1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       let cell = collectionView
          .dequeueReusableCell(withReuseIdentifier: "ImageCollectionCell", for: indexPath) as! ImageCollectionCell
        // Configure the cell
        cell.setData()
        
        if indexPath.row == 0{
            //Default add icon
            //cell.imageStory.backgroundColor = Constants.Colors.APP_COLOR
            cell.imageStory.image = UIImage(named: "Share-ic")
        }else{
            let image = self.userDetails?.data?.stories?[indexPath.row-1].image?.thumbnail
            if image?.contains("http") ?? false{
                cell.imageStory.setImage(with: image ?? "")
            }else{
                cell.imageStory.image = UIImage(named: "placeholder")
            }
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0{
             self.imagePicker.present(from: btnEdit)
        }else{
           
            guard let image = self.userDetails?.data?.stories?[indexPath.row-1].image?.original, image != "" else {return}
            let controller = self.storyboard?.instantiateViewController(identifier: "ImagePopupController") as! ImagePopupController
            
            controller.original = image
            self.present(controller, animated: false, completion: nil)
            
        }
    }
}
//MARK:- ImagePicker Delegate
extension MyProfileController: ImagePickerDelegate{
     func didSelect(image: UIImage?) {
        if image != nil{
             self.apiUploadImage(image: image!)
        }
    }
}
// MARK: - Collection View Flow Layout Delegate
extension MyProfileController : UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    return CGSize(width: 55, height: 55)
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 10
  }
}


extension MyProfileController: CarbonTabSwipeNavigationDelegate{
    private func configureTabBar(){
        let items = ["Visited Places"]
        let carbonTabSwipeNavigation = CarbonTabSwipeNavigation(items: items, delegate: self)
        carbonTabSwipeNavigation.insert(intoRootViewController: self, andTargetView: containerView)
        let widthOfTabs = Constants.Screen.width
        carbonTabSwipeNavigation.carbonSegmentedControl?.setWidth(widthOfTabs, forSegmentAt: 0)
        //carbonTabSwipeNavigation.carbonSegmentedControl?.setWidth(widthOfTabs, forSegmentAt: 1)
        carbonTabSwipeNavigation.setAppStypeTab()
    }
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAt index: UInt) -> UIViewController {
           let vc = self.storyboard?.instantiateViewController(identifier: "VistitedPlacesController") as! VistitedPlacesController
           //vc.comments = self.userDetails?.data?.reviews
           vc.placeVisited = self.userDetails?.data?.placeVisted
           vc.idx = Int(index)
           return vc
       }
}
extension CarbonTabSwipeNavigation {
    func setAppStypeTab() {
        self.toolbar.barTintColor = Constants.Colors.WHITE_COLOR
        self.setSelectedColor(Constants.Colors.BLACK_COLOR)
        self.setIndicatorColor(Constants.Colors.BLACK_COLOR)
        self.setNormalColor(Constants.Colors.BLACK_COLOR)
        self.setIndicatorHeight(1.5)
        self.setSelectedColor(Constants.Colors.BLACK_COLOR, font: Font.AppFont.bold.with(size: 15))
        self.setNormalColor(Constants.Colors.BLACK_COLOR, font: Font.AppFont.regular.with(size: 15))
    }
}
extension MyProfileController{
    func getProfile(){
        self.showLoading()
        ApiHandler.call(apiName: Constant.API.MY_PROFILE, params: nil, httpMethod: .GET) { (isSucceeded, response, data) in
                  DispatchQueue.main.async {
                  print(isSucceeded)
                  self.hideLoading()
                  if isSucceeded == true {
                      print(response)
                      guard let data = data else { return }
                                          do {
                      self.userDetails = try JSONDecoder().decode(LoginModel.self, from: data)
                       if let status = self.userDetails?.data?.status {
                           AppManager.sharedInstance.userStatus = status
                       }
                       if let userName = self.userDetails?.data?.userName {
                           AppManager.sharedInstance.userName = userName
                       }
                       if let firstName = self.userDetails?.data?.firstName {
                           AppManager.sharedInstance.firstName = firstName
                       }
                       if let lastName = self.userDetails?.data?.lastName {
                           AppManager.sharedInstance.lastName = lastName
                       }
                       if let userConnections = self.userDetails?.data?.totalConnections {
                           AppManager.sharedInstance.userConnections = userConnections
                       }
                        if let email = self.userDetails?.data?.email {
                            AppManager.sharedInstance.userEmail = email
                        }
                        if let bio = self.userDetails?.data?.bio {
                            AppManager.sharedInstance.userBio = bio
                        }
                        let image = self.userDetails?.data?.image?.original
                        AppManager.sharedInstance.userPhoto = image
                        AppManager.sharedInstance.userPhotoThumb = self.userDetails?.data?.image?.thumbnail
                        if image?.contains("http") ?? false{
                            self.profileImage.setImage(with: image ?? "")
                        }else{
                            self.profileImage.image = UIImage(named: "placeholder")
                        }
                     
                                            self.setUserDetails()
                                            self.collectionView.reloadData()
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
    func apiUploadImage(image: UIImage){
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
                            self.uploadStories(imageData:jsonResponse.data)
                           
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
    func uploadStories(imageData: ImageData?) {
        self.showLoading()
        var json = [String: String]()
        json[APIKey.original] = imageData?.original
        json[APIKey.thumbnail] = imageData?.thumb
        print("json = ", json)
        let finalJson = ["image":[json]]
        ApiHandler.call(apiName: Constant.API.STORIES_UPLOAD, params: finalJson, httpMethod: .POST) { (isSucceeded, response, data) in
            DispatchQueue.main.async {
                self.hideLoading()
                if isSucceeded == true {
                    print(response)
                    self.getProfile()
                }
            }
        }
    }
}

