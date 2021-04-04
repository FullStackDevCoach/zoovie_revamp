//
//  BookingController.swift
//  Zoovie
//
//  Created by MAC on 26/02/19.
//  Copyright © 2019 rakesh. All rights reserved.
//

import UIKit

protocol BookingControllerDelegate {
    func orderAction(bookingArray: [Tickets])
}

class BookingController: UIViewController {
    @IBOutlet weak var bookingTable: UITableView!
    
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    var delegate:BookingControllerDelegate?
    
    var countCell:Int = 0
    //var vipPerson = ["General","VipGeneral","VipSelection","VIP Selection1"]
    var eventData:EventData?
    //var indexPath:[Int]?
    
    var bookingArray = [Tickets]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setBookingTable()
        self.setGestureRecogeniser()
    }
    func setArray() {
        self.bookingArray = eventData!.tickets!
        self.bookingTable.reloadData()
        print(self.bookingArray)
    }
    
    func setBookingTable() {
        self.bookingTable.delegate = self
        self.bookingTable.dataSource = self
        self.bookingTable.register(UINib(nibName: "BookingTableCell", bundle: nil), forCellReuseIdentifier: "BookingTableCell")
        self.setTableHeader()
        self.setTableFooter()
    }
    
    func setTableHeader() {
        let headerView = UINib(nibName: "BookingTableHeader", bundle: nil).instantiate(withOwner: self, options: nil)[0] as? BookingTableHeader
        headerView?.frame = CGRect(x: 0, y: 0, width: Constants.Screen.width, height: 60)
        self.bookingTable.tableHeaderView = headerView
    }
    
    func setTableFooter() {
        let footerView = UINib(nibName: "BookingFooterView", bundle: nil).instantiate(withOwner: self, options: nil)[0] as? BookingFooterView
        footerView?.frame = CGRect(x: 0, y: 0, width: Constants.Screen.width, height: footerView?.frame.height ?? 82)
        footerView?.orderButton.addTarget(self, action: #selector(self.orderAction), for: .touchUpInside)
        self.bookingTable.tableFooterView = footerView
    }
    
    func setGestureRecogeniser() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped))
        tap.cancelsTouchesInView = false
        tap.numberOfTapsRequired = 1
        tap.delegate = self
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func tapped() {
        self.dismiss(animated: false, completion: nil)
    }
    
    @objc func orderAction() {
        let isQuantity:Bool = self.isQuantityAvailable()
        if isQuantity == true {
            self.dismiss(animated: false, completion: nil)
            self.delegate?.orderAction(bookingArray: self.bookingArray)
        } else {return}
    }
    
    func isQuantityAvailable() -> Bool {
        for value in bookingArray {
            if (value.currentQuantity ?? 0) > 0 {
                return true
            }
        }
        return false
    }
    func setTotalTicketsCount(selectedTicketId: String, totalValue: Int){
        for i in 0..<self.bookingArray.count{
            if selectedTicketId == self.bookingArray[i]._id{
                self.bookingArray[i].currentQuantity = totalValue
            }else{
                self.bookingArray[i].currentQuantity = 0
            }
        }
    }
}

extension BookingController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(self.bookingArray.count == 3){
            return self.bookingArray.count + 1
        }else{
            return self.bookingArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookingTableCell") as? BookingTableCell
        countCell += 1
        
        if(bookingArray.count == 3){
            
            if(indexPath.row < bookingArray.count){
                
                cell?.itemNameLabel.isHidden = false
                cell?.itemPriseLabel.isHidden = false
                cell?.lineView.isHidden = false
                cell?.parentView = self
                let listing = self.bookingArray[indexPath.row]
                //listing.currentQuantity = 0
                cell?.itemNameLabel.text = listing.category
                cell?.itemPriseLabel.text = "$\(listing.price!)"
                if(listing.remaining! > 0){
                    cell?.animatableView.isHidden = false
                    cell?.soldLbl.isHidden = true
                }else{
                    cell?.animatableView.isHidden = true
                    cell?.soldLbl.isHidden = false
                    
                }
                cell?.setData(booking: listing,isViaBooking: true)
                return cell!
            }else{
                cell?.itemNameLabel.isHidden = true
                cell?.itemPriseLabel.isHidden = true
                cell?.lineView.isHidden = true
                cell?.animatableView.isHidden = true
                cell?.soldLbl.isHidden = true

                return cell!
            }
            
        }else{
            
            cell?.itemNameLabel.isHidden = false
            cell?.itemPriseLabel.isHidden = false
            cell?.lineView.isHidden = false
            cell?.parentView = self
            let listing = self.bookingArray[indexPath.row]
            //listing.currentQuantity = 0
            cell?.itemNameLabel.text = listing.category
            cell?.itemPriseLabel.text = "$\(listing.price!)"
            
            if(listing.remaining! > 0){
                cell?.animatableView.isHidden = false
                cell?.soldLbl.isHidden = true

            }else{
                cell?.animatableView.isHidden = true
                cell?.soldLbl.isHidden = false
            }
            cell?.setData(booking: listing,isViaBooking: true)
            return cell!
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 84
    }
}

extension BookingController:UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view?.isDescendant(of: bookingTable))! == true {
            return false
        }
        return true
    }
}

extension BookingController: BookingTableCellDelegate {
    func tableFooterData(price: Double, index: Int) {
        self.setTableFooter()
    }
    func reloadTable() {
        self.bookingTable.reloadData()
    }
}
