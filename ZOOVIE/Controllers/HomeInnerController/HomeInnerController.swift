//
//  HomeInnerController.swift
//  ZOOVIE
//
//  Created by abc on 15/05/20.
//  Copyright © 2020 Zoovie. All rights reserved.
//

import UIKit
import Kingfisher

class HomeInnerController: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet weak var tableView: UITableView!{
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.tableFooterView = UIView()
            tableView.register(UINib(nibName: "HomeDetailsCell", bundle: nil), forCellReuseIdentifier: "HomeDetailsCell")
            tableView.register(UINib(nibName: "InnerEventCell", bundle: nil), forCellReuseIdentifier: "InnerEventCell")
            
        }
    }
    var clubId: String?
    var selectedEventDetail : EventData?
    var arrayArtist : [Artist]?
    var arrayUpcomingEvents : [EventData]?
    var selectedEventIndex = 0
    var dateEvent:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //self.getArtists()
        self.tableView.isHidden = true
        self.getUpComingEvents()
    }
    func openOtherProfile(){
        let vc = self.storyboard?.instantiateViewController(identifier: "OtherUserProfileController") as! OtherUserProfileController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.setNavigationBarTitle(title: "EXCLUSIVE EVENT")
        self.setLeftBackButton()
    }


}
extension HomeInnerController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1+(arrayUpcomingEvents?.count ?? 0)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeDetailsCell", for: indexPath) as! HomeDetailsCell
            cell.nameLabel.text = self.selectedEventDetail?.name ?? ""
            cell.slotLabel.text = "\(self.selectedEventDetail?.performanceSlot?.count ?? 0) SLOT LIMIT"
            cell.timeLabel.text = self.selectedEventDetail?.date?.getDate() ?? ""
            self.dateEvent = self.selectedEventDetail?.date?.getDate() ?? ""
            cell.priceLabel.text = "$ \(self.selectedEventDetail?.performancePrice ?? 00)"
            cell.lblAbout.text = self.selectedEventDetail?.about ?? ""
            let imageEvent =  self.selectedEventDetail?.images?.first?.original ?? ""
            if imageEvent.contains("http"){
                cell.eventImageView.setImage(with: imageEvent)
            }else{
                cell.eventImageView.image = UIImage(named: "placeholder")
            }
            cell.collectionView.reloadData()
            cell.parentView = self
            cell.btnShare.addTarget(self, action: #selector(actionShare), for: .touchUpInside)
            cell.btnLike.tag = selectedEventIndex
            cell.btnLike.addTarget(self, action: #selector(likeEventApi(sender:)), for: .touchUpInside)
            cell.btnLike.setTitle("\(selectedEventDetail?.totalLikes ?? 0) Likes", for: .normal)
            if self.selectedEventDetail?.isLike ?? false == false{
                cell.btnLike.setImage(UIImage(named: "like-ic"), for: .normal)
            }else{
                cell.btnLike.setImage(UIImage(named: "liked-ic"), for: .normal)
            }
            cell.btnTickets.addTarget(self, action: #selector(actionTickets), for: .touchUpInside)
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "InnerEventCell", for: indexPath) as! InnerEventCell
            let imageEvent =  self.arrayUpcomingEvents?[indexPath.section-1].images?.first?.original ?? ""
           if imageEvent.contains("http"){
                cell.imgItem.setImage(with: imageEvent)
            }else{
                cell.imgItem.image = UIImage(named: "placeholder")
            }
            cell.btnLike.setTitle("\(self.arrayUpcomingEvents?[indexPath.section-1].totalLikes ?? 0) Likes", for: .normal)
            //cell.btnComment.setTitle("\(self.arrayUpcomingEvents?[indexPath.section-1].totalComments ?? 0) Comments", for: .normal)
            
            cell.btnComment.isHidden = true
            cell.btnLike.addTarget(self, action: #selector(likeEventApi(sender:)), for: .touchUpInside)
            cell.btnLike.tag = indexPath.section-1
            if self.arrayUpcomingEvents?[indexPath.section-1].isLike ?? false == false{
                cell.btnLike.setImage(UIImage(named: "like-ic"), for: .normal)
            }else{
                cell.btnLike.setImage(UIImage(named: "liked-ic"), for: .normal)
            }
            return cell
        }
       
    }
    @objc func actionShare(){
        AppManager.sharedInstance.shareAppUrl(view: self)
    }
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section != 0{
            selectedEventDetail = self.arrayUpcomingEvents?[indexPath.section-1]
            self.arrayArtist = self.selectedEventDetail?.artist
            self.tableView.reloadData()
            self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: UITableView.ScrollPosition.top, animated: true)
            
//            let vc = self.storyboard?.instantiateViewController(identifier: "EventInnerController") as! EventInnerController
//            vc.eventData = self.arrayUpcomingEvents?[indexPath.section-1]
//            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return UITableView.automaticDimension
        }
        return 200
    }
    
     func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = Constants.Colors.LIGHT_SEPRATOR_COLOR
        return view
    }
    
     func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    @objc func actionTickets(){
        let controller = self.storyboard?.instantiateViewController(identifier: "BookingController") as! BookingController
        controller.eventData = self.selectedEventDetail
        controller.delegate = self
        self.present(controller, animated: false, completion: {
            controller.setArray()
        })
    }
}
extension HomeInnerController: BookingControllerDelegate{
    func orderAction(bookingArray: [Tickets]) {
        print(self.selectedEventDetail?._id ?? "not found event id")
        let controller = self.storyboard?.instantiateViewController(identifier: "BookingPreviewController") as! BookingPreviewController
        controller.bookingArray = bookingArray
        controller.eventData = self.selectedEventDetail
        controller.dateEvent = self.dateEvent
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
extension HomeInnerController{
    /*func getArtists(){
       self.showLoading()
        ApiHandler.call(apiName: Constant.API.events(id: self.eventDetail?._id ?? ""), params: nil, httpMethod: .GET) { (isSucceeded, response, data) in
                 DispatchQueue.main.async {
                 print(isSucceeded)
                 self.hideLoading()
                 if isSucceeded == true {
                     print(response)
                     guard let data = data else { return }
                    do {
                    let homeDetails = try JSONDecoder().decode(ArtistModel.self, from: data)
                    self.arrayArtist = homeDetails.data?[0].artist
                    self.tableView.reloadData()
                    }catch{}
                 } else {
                     if let message = response["message"] as? String {
                         self.showAlert(alertMessage: message)
                     }
                 }
             }
         }
    }*/
    func getUpComingEvents(){
       self.showLoading()
        //5cb8bd83d0d7cf3719415009
        //self.clubId ??
        ApiHandler.call(apiName: Constant.API.clubDetails(id:  self.clubId ?? ""), params: nil, httpMethod: .GET) { (isSucceeded, response, data) in
                 DispatchQueue.main.async {
                 print(isSucceeded)
                 self.hideLoading()
                 if isSucceeded == true {
                     print(response)
                     guard let data = data else { return }
                    do {
                    let clubDetails = try JSONDecoder().decode(EventsModel.self, from: data)
                        if clubDetails.data?.count ?? 0 > 0{
                            self.tableView.isHidden = false
                            self.arrayUpcomingEvents = clubDetails.data
                            self.selectedEventDetail = self.arrayUpcomingEvents?[0]
                            self.arrayArtist = self.selectedEventDetail?.artist
                            self.tableView.reloadData()
                        }
                    
                    }catch{}
                 } else {
                     if let message = response["message"] as? String {
                         self.showAlert(alertMessage: message)
                     }
                 }
             }
         }
      
    }
    @objc func likeEventApi(sender: UIButton){
        selectedEventIndex = sender.tag
        if self.arrayUpcomingEvents?[sender.tag].isLike ?? false == true{
            actionLikeApi(status: false)
        }else{
            actionLikeApi(status: true)
        }
    }
    func actionLikeApi(status: Bool){
       self.showLoading()
        ApiHandler.call(apiName: Constant.API.LIKE_EVENT, params: [APIKey.eventId: self.arrayUpcomingEvents?[selectedEventIndex]._id ?? "", APIKey.isLike: status], httpMethod: .POST) { (isSucceeded, response, data) in
                 DispatchQueue.main.async {
                 print(isSucceeded)
                 self.hideLoading()
                 if isSucceeded == true {
                     print(response)
                    // guard let data = data else { return }
                    //do {
                    self.arrayUpcomingEvents?[self.selectedEventIndex].isLike = status
                    let totalLikes = self.arrayUpcomingEvents?[self.selectedEventIndex].totalLikes ?? 0
                        if status{
                            self.arrayUpcomingEvents?[self.selectedEventIndex].totalLikes = totalLikes+1
                        }else{
                            self.arrayUpcomingEvents?[self.selectedEventIndex].totalLikes = totalLikes-1
                        }
                    //pod 'Firebase/Analytics'
                    self.selectedEventDetail = self.arrayUpcomingEvents?[self.selectedEventIndex]
                        self.tableView.reloadData()
                 } else {
                     if let message = response["message"] as? String {
                         self.showAlert(alertMessage: message)
                     }
                 }
             }
         }
    }
}
