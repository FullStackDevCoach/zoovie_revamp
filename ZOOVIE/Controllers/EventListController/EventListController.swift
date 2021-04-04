//
//  EventListController.swift
//  ZOOVIE
//
//  Created by abc on 13/05/20.
//  Copyright © 2020 Zoovie. All rights reserved.
//

import UIKit

class EventListController: UIViewController {

    @IBOutlet weak var tableView: UITableView!{
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.tableFooterView = UIView()
            tableView.register(UINib(nibName: "EventsCell", bundle: nil), forCellReuseIdentifier: "EventsCell")
            
        }
    }
    
    //MARK:- Variables
    var states : Array<Bool>!
    var eventDetails: [EventData]?
    var selectedTicketIndex = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        congifView()
        getUpComingEvents()
    }
    private func congifView(){
         
    }

}
extension EventListController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.eventDetails?.count ?? 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "EventsCell", for: indexPath) as! EventsCell
        cell.lblAbout.delegate = self
        
        cell.lblAbout.setLessLinkWith(lessLink: "Less", attributes: [.foregroundColor: Constants.Colors.APP_COLOR], position: .left)
        
        cell.layoutIfNeeded()
        
        cell.lblAbout.shouldCollapse = true
        cell.lblAbout.numberOfLines = 5
        cell.lblAbout.collapsed = states[indexPath.row]
        cell.lblAbout.text = self.eventDetails?[indexPath.section].about
        cell.lblTotalSlots.text = "\(self.eventDetails?[indexPath.section].performanceSlot?.count ?? 0)"
        if self.eventDetails?[indexPath.section].eventDate ?? "" != ""{
             cell.lblDate.text = AppManager.sharedInstance.convertDateFormaterDynamic(self.eventDetails?[indexPath.section].eventDate ?? "", fromFormat: Constants.DateFormats.kEventDateApi, toFormat: Constants.DateFormats.kEventDate)
        }else{
             cell.lblDate.text = ""
        }
       
        cell.lblHashTag.text = "@\(self.eventDetails?[indexPath.section].tags?.joined(separator: "#") ?? "")"
        cell.lblUserName.text = "\(self.eventDetails?[indexPath.section].artist?.first?.firstName ?? "") \(self.eventDetails?[indexPath.section].artist?.first?.lastName ?? "")"
        let imageUser = self.eventDetails?[indexPath.section].artist?.first?.image?.original ?? ""
        if imageUser.contains("http"){
            cell.imgUser.setImage(with: imageUser)
        }else{
            cell.imgUser.image = UIImage(named: "placeholder")
        }
        //cell.btnComments.setTitle("\(self.eventDetails?.data?[indexPath.section].totalComments ?? 0) Comments", for: .normal)
        cell.btnComments.isHidden = true
        cell.btnLike.setTitle("\(self.eventDetails?[indexPath.section].totalLikes ?? 0) Likes", for: .normal)
        let image = self.eventDetails?[indexPath.section].images?.first?.original ?? ""
        if image.contains("http"){
            cell.imgVenue.setImage(with: image)
        }else{
            cell.imgVenue.image = UIImage(named: "placeholder")
        }
        cell.btnLike.addTarget(self, action: #selector(likeEventApi(sender:)), for: .touchUpInside)
        cell.btnLike.tag = indexPath.section
        if self.eventDetails?[indexPath.section].isLike ?? false == false{
            cell.btnLike.setImage(UIImage(named: "like-ic"), for: .normal)
        }else{
            cell.btnLike.setImage(UIImage(named: "liked-ic"), for: .normal)
        }
        cell.btnTickets.addTarget(self, action: #selector(actionOrder(sender:)), for: .touchUpInside)
        cell.btnTickets.tag = indexPath.section
        cell.btnShare.addTarget(self, action: #selector(actionShare), for: .touchUpInside)
        return cell
    }
    @objc func actionShare(){
        AppManager.sharedInstance.shareAppUrl(view: self)
    }
    @objc func actionOrder(sender: UIButton){
        selectedTicketIndex = sender.tag
        if self.eventDetails?[sender.tag].tickets?.count ?? 0 > 0{
            let vc = self.storyboard?.instantiateViewController(identifier: "OrderTicketController") as! OrderTicketController
            vc.modalPresentationStyle = .overCurrentContext
            vc.modalTransitionStyle = .crossDissolve
            vc.delegate = self
            vc.bookingArray = self.eventDetails?[sender.tag].tickets ?? []
            self.present(vc, animated: true)
        }else{
            self.showAlert(alertMessage: "Tickets not found")
        }
        
       
    }
    // MARK: - UITableViewDelegate
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
     func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = Constants.Colors.LIGHT_SEPRATOR_COLOR
        return view
    }
    
     func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
}
extension EventListController: OrderControllerDelegate{
    func orderAction(bookingArray: [Tickets]) {
        print(self.eventDetails?[self.selectedTicketIndex]._id ?? "not found event id")
        let controller = self.storyboard?.instantiateViewController(identifier: "BookingPreviewController") as! BookingPreviewController
        controller.bookingArray = bookingArray
        controller.eventType = "online"
        controller.eventData = self.eventDetails?[self.selectedTicketIndex]
        controller.dateEvent = self.eventDetails?[self.selectedTicketIndex].date?.getDate() ?? ""
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
 // MARK: ExpandableLabel Delegate

extension EventListController: ExpandableLabelDelegate{
    func willExpandLabel(_ label: ExpandableLabel) {
        tableView.beginUpdates()
    }
    
    func didExpandLabel(_ label: ExpandableLabel) {
        let point = label.convert(CGPoint.zero, to: tableView)
        if let indexPath = tableView.indexPathForRow(at: point) as IndexPath? {
            states[indexPath.row] = false
            DispatchQueue.main.async { [weak self] in
                self?.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
            }
        }
        tableView.endUpdates()
    }
    
    func willCollapseLabel(_ label: ExpandableLabel) {
        tableView.beginUpdates()
    }
    
    func didCollapseLabel(_ label: ExpandableLabel) {
        let point = label.convert(CGPoint.zero, to: tableView)
        if let indexPath = tableView.indexPathForRow(at: point) as IndexPath? {
            states[indexPath.row] = true
            DispatchQueue.main.async { [weak self] in
                self?.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
            }
        }
        tableView.endUpdates()
    }
    
    
}
extension EventListController{
    func getUpComingEvents(){
       self.showLoading()
        ApiHandler.call(apiName: Constant.API.GET_ONLINE_EVENTS, params: nil, httpMethod: .GET) { (isSucceeded, response, data) in
                 DispatchQueue.main.async {
                 print(isSucceeded)
                 self.hideLoading()
                 if isSucceeded == true {
                     guard let data = data else { return }
                    do {
                        print(response)
                        let response = try JSONDecoder().decode(EventsModel.self, from: data)
                        print(response.data)
                        self.eventDetails = response.data
                        self.states = [Bool](repeating: true, count: self.eventDetails?.count ?? 0)
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
    @objc func likeEventApi(sender: UIButton){
        if self.eventDetails?[sender.tag].isLike ?? false == true{
            actionLikeApi(status: false, index: sender.tag)
        }else{
            actionLikeApi(status: true, index: sender.tag)
        }
    }
    func actionLikeApi(status: Bool, index: Int){
       self.showLoading()
        ApiHandler.call(apiName: Constant.API.LIKE_EVENT, params: [APIKey.eventId: "self.eventDetails?[index]._id ?? ", APIKey.isLike: status], httpMethod: .POST) { (isSucceeded, response, data) in
                 DispatchQueue.main.async {
                 print(isSucceeded)
                 self.hideLoading()
                 if isSucceeded == true {
                     print(response)
                    // guard let data = data else { return }
                    //do {
                    self.eventDetails?[index].isLike = status
                    let totalLikes = self.eventDetails?[index].totalLikes ?? 0
                    if status{
                       self.eventDetails?[index].totalLikes = totalLikes+1
                    }else{
                        self.eventDetails?[index].totalLikes = totalLikes-1
                    }
                    self.tableView.reloadData()
                   // }catch{}
                 } else {
                     if let message = response["message"] as? String {
                         self.showAlert(alertMessage: message)
                     }
                 }
             }
         }
    }
   
}
