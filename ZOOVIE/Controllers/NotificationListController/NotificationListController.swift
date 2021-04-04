//
//  NotificationListController.swift
//  ZOOVIE
//
//  Created by abc on 14/05/20.
//  Copyright © 2020 Zoovie. All rights reserved.
//

import UIKit

class NotificationListController: UIViewController {

    @IBOutlet weak var tableView: UITableView!{
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.tableFooterView = UIView()
            tableView.register(UINib(nibName: "NotificationHeaderCell", bundle: nil), forCellReuseIdentifier: "NotificationHeaderCell")
            tableView.register(UINib(nibName: "MessagesCell", bundle: nil), forCellReuseIdentifier: "MessagesCell")
            tableView.register(UINib(nibName: "TicketsCollectionViewCell", bundle: nil), forCellReuseIdentifier: "TicketsCollectionViewCell")
            tableView.register(UINib(nibName: "TableCollectionViewCell", bundle: nil), forCellReuseIdentifier: "TableCollectionViewCell")
            
        }
    }
    var notificationData: NotificationData?
    var sectionRows = [0, 0, 0]
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.getNotificationList()
    }
  

}
extension NotificationListController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            if self.notificationData?.messages?.count ?? 0 > 4{
                return 4
            }
            return self.notificationData?.messages?.count ?? 0
        case 2:
            if self.notificationData?.notifications?.count ?? 0 > 4{
                return 4
            }
            return self.notificationData?.notifications?.count ?? 0
        default:
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch indexPath.section{
            //TICKETS
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TableCollectionViewCell", for: indexPath) as! TableCollectionViewCell
            cell.parentView = self
            cell.collectionView.reloadData()
            
            return cell
        case 1:
            //MESSAGES
            let cell = tableView.dequeueReusableCell(withIdentifier: "MessagesCell", for: indexPath) as! MessagesCell
            cell.setMessagesData(message: self.notificationData?.messages?.reversed()[indexPath.row].message ?? "")
            return cell
        case 2:
             //NOTIFICATIONS
             let cell = tableView.dequeueReusableCell(withIdentifier: "MessagesCell", for: indexPath) as! MessagesCell
             cell.setNotificationsData(message: self.notificationData?.messages?.reversed()[indexPath.row].message ?? "")
             return cell
        default:
            return UITableViewCell()
        }
        
    }
    
    // MARK: - UITableViewDelegate
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 200
        default:
            return UITableView.automaticDimension
        }
    }
     func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationHeaderCell") as! NotificationHeaderCell
        let view = UIView(frame: CGRect(x: 0, y: 0, width: Constants.Screen.width, height: 50))
        cell.frame = view.frame
        cell.btnSeeAll.tag = section
        cell.btnSeeAll.addTarget(self, action: #selector(actionSeeAll(sender:)), for: .touchUpInside)
        view.addSubview(cell)
        switch section {
        case 0:
            cell.lblTitle.text = "TICKETS"
            view.backgroundColor = Constants.Colors.LIGHT_SEPRATOR_COLOR
            if self.notificationData?.tickets?.count ?? 0 <= 4{
                cell.btnSeeAll.isHidden = true
            }else{
                cell.btnSeeAll.isHidden = false
            }
            break;
        case 1:
            cell.lblTitle.text = "MESSAGES"
            view.backgroundColor = Constants.Colors.WHITE_COLOR
            if self.notificationData?.messages?.count ?? 0 <= 4{
                cell.btnSeeAll.isHidden = true
            }else{
                cell.btnSeeAll.isHidden = false
            }
            break;
        case 2:
            cell.lblTitle.text = "NOTIFICATIONS"
            view.backgroundColor = Constants.Colors.LIGHT_SEPRATOR_COLOR
            if self.notificationData?.notifications?.count ?? 0 <= 4{
                cell.btnSeeAll.isHidden = true
            }else{
                cell.btnSeeAll.isHidden = false
            }
            break;
        default:
            return view
        }
        return view
    }
    
     func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    @objc func actionSeeAll(sender: UIButton){
        
    }
}
extension NotificationListController{
    func getNotificationList(){
       self.showLoading()
        ApiHandler.call(apiName: Constant.API.NOTIFICATION, params: nil, httpMethod: .GET) { (isSucceeded, response, data) in
                 DispatchQueue.main.async {
                 print(isSucceeded)
                 self.hideLoading()
                 if isSucceeded == true {
                     print(response)
                     guard let data = data else { return }
                    do {
                        let response = try JSONDecoder().decode(NotificationModel.self, from: data)
                        self.notificationData = response.data
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
}
