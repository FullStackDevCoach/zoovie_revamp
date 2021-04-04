//
//  HomeController.swift
//  ZOOVIE
//
//  Created by abc on 12/05/20.
//  Copyright © 2020 Zoovie. All rights reserved.
//

import UIKit
import Kingfisher

class HomeController: UIViewController {

    @IBOutlet weak var tableView: UITableView!{
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.tableFooterView = UIView()
            tableView.register(UINib(nibName: "VenuesCell", bundle: nil), forCellReuseIdentifier: "VenuesCell")
            tableView.register(UINib(nibName: "VenueHeaderCell", bundle: nil), forCellReuseIdentifier: "VenueHeaderCell")
            
        }
    }
    var homeDetails : HomePageModel?
    var currentCity = ""
    var cityArr = [String]()
    var CityDetails : CitiesModel?
    var tabBarView = UIView()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        getCities()
    }
    func getCities(){
        self.showLoading()
        ApiHandler.call(apiName: Constant.API.GET_CITIES, params: nil, httpMethod: .GET) { (isSucceeded, response, data) in
            
                print(response)
                self.hideLoading()
                if isSucceeded == true {
                     guard let data = data else { return }
                    do {
                    self.CityDetails = try JSONDecoder().decode(CitiesModel.self, from: data)
                        if self.CityDetails?.data?.count != 0 {
                            for i in self.CityDetails?.data ?? [] {
                                if i.state_name != "" || i.state_name == nil {
                                    self.cityArr.append(i.state_name ?? "")
                                }
                            }
                            self.currentCity = self.cityArr.first ?? ""
                            //self.currentCity = "Alaska"
                            self.getClubs()
                        }
                    }catch{}
                } else {
                if let message = response["message"] as? String {
                    self.showAlert(alertMessage: message)
                }
            }
            
        }
    }
    func getClubs(){
       self.showLoading()
        print(Constant.API.clubs(city: self.currentCity))
        ApiHandler.call(apiName: Constant.API.clubs(city: self.currentCity), params: nil, httpMethod: .GET) { (isSucceeded, response, data) in
                 DispatchQueue.main.async {
                 print(isSucceeded)
                 self.hideLoading()
                 if isSucceeded == true {
                     print(response)
                     guard let data = data else { return }
                    do {
                    self.homeDetails = try JSONDecoder().decode(HomePageModel.self, from: data)
                    self.tableView.reloadData()
                    }catch{}
                 } else {
                     if let message = response["message"] as? String {
                         self.showAlert(alertMessage: message)
                     }
                 }
             }
         }
      
    }
    @objc func editBtnAction(_ sender : UIButton){
        if self.cityArr.count == 0{
            self.showAlert(alertMessage: "Cities not available")
        }else{
            RPicker.selectOption(title: "Select city", cancelText: "Cancel", doneText: "Done", dataArray: self.cityArr, selectedIndex: 0) { (value, index) in
                       self.currentCity = self.cityArr[index]
                    self.getClubs()
                       print(self.currentCity)
                }
            }
       }

}
 
extension HomeController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.homeDetails?.data?.clubs?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "VenuesCell", for: indexPath) as! VenuesCell
        cell.venueName.text = self.homeDetails?.data?.clubs?[indexPath.row].name ?? ""
        cell.venueAddress.text = self.homeDetails?.data?.clubs?[indexPath.row].city ?? ""
       
        let imageUser = self.homeDetails?.data?.clubs?[indexPath.row].images?.first?.original ?? ""
        if imageUser.contains("http"){
            cell.imgVenue.setImage(with: imageUser)
        }else{
            cell.imgVenue.image = UIImage(named: "placeholder")
        }
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(identifier: "HomeInnerController") as! HomeInnerController
        vc.clubId = self.homeDetails?.data?.clubs?[indexPath.row]._id
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
     }
     func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VenueHeaderCell") as! VenueHeaderCell
        let view = UIView(frame: CGRect(x: 0, y: 0, width: Constants.Screen.width, height: 50))
        cell.frame = view.frame
        view.addSubview(cell)
        view.backgroundColor = Constants.Colors.WHITE_COLOR
        cell.lblHeaderName.text = "\(self.currentCity) VENUES"
        cell.btnEdit.addTarget(self, action: #selector(editBtnAction(_:)), for: .touchUpInside)
        return view
    }
     func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}
