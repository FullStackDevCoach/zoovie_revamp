//
//  OtherUserProfileController.swift
//  ZOOVIE
//
//  Created by SFS on 21/05/20.
//  Copyright © 2020 Zoovie. All rights reserved.
//

import UIKit
import CarbonKit

class OtherUserProfileController: UIViewController {

    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var userProfile: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblBio: UILabel!
    @IBOutlet weak var btnConnect: UIButton!
    
        var userId = ""
        var userDetails : LoginModel?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureTabBar()
        getProfile()
    }

    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(true)
       //let image = UIImage(named: "logo")
        self.setNavigationBarTitle(title: "Other Profile")
        self.setLeftBackButton()
    }
    @IBAction func actionConnect(_ sender: Any) {
        
    }
    
    func setUserDetails(){
        let image = self.userDetails?.data?.image?.thumbnail
        if image?.contains("http") ?? false{
            self.userProfile.setImage(with: image ?? "")
        }else{
            self.userProfile.image = UIImage(named: "placeholder")
        }
        self.lblUserName.text = "\(self.userDetails?.data?.firstName ?? "") \(self.userDetails?.data?.firstName ?? "")"
        self.lblBio.text = (self.userDetails?.data?.bio ?? "")
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
    extension OtherUserProfileController: CarbonTabSwipeNavigationDelegate{
        private func configureTabBar(){
            let items = ["Visited Places", "Comments"]
            let carbonTabSwipeNavigation = CarbonTabSwipeNavigation(items: items, delegate: self)
            carbonTabSwipeNavigation.insert(intoRootViewController: self, andTargetView: containerView)
            let widthOfTabs = Constants.Screen.width/2
            carbonTabSwipeNavigation.carbonSegmentedControl?.setWidth(widthOfTabs, forSegmentAt: 0)
            carbonTabSwipeNavigation.carbonSegmentedControl?.setWidth(widthOfTabs, forSegmentAt: 1)
            carbonTabSwipeNavigation.setAppStypeTab()
        }
        func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAt index: UInt) -> UIViewController {
               switch index {
               case 0:
                return self.storyboard?.instantiateViewController(identifier: "VistitedPlacesController") as! VistitedPlacesController
               case 1:
                   return self.storyboard?.instantiateViewController(identifier: "VistitedPlacesController") as! VistitedPlacesController
               default:
                   return UIViewController()
               }
           }
    }
extension OtherUserProfileController{
func getProfile(){
    self.showLoading()
    ApiHandler.call(apiName: Constant.API.othersProfile(id: userId), params: nil, httpMethod: .GET) { (isSucceeded, response, data) in
              DispatchQueue.main.async {
              print(isSucceeded)
              self.hideLoading()
              if isSucceeded == true {
                  print(response)
                  guard let data = data else { return }
                                      do {
                  self.userDetails = try JSONDecoder().decode(LoginModel.self, from: data)
                
                                        self.setUserDetails()
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
