//
//  BookingTableCell.swift
//  Zoovie
//
//  Created by MAC on 26/02/19.
//  Copyright © 2019 rakesh. All rights reserved.
//

import UIKit
import IBAnimatable

protocol BookingTableCellDelegate {
    func tableFooterData(price: Double, index: Int)
    func reloadTable()
}


class BookingTableCell: UITableViewCell {
    @IBOutlet weak var valueLabel: AnimatableLabel!
    @IBOutlet weak var itemPriseLabel: UILabel!
    @IBOutlet weak var itemNameLabel: UILabel!
    
    @IBOutlet var soldLbl: UILabel!
    @IBOutlet var animatableView: AnimatableView!
    @IBOutlet var lineView: UIView!
    var delegate:BookingTableCellDelegate?
    var selectedBooking:Tickets?

    var totalQuantity:Int = 0
    var indexNumber:Int = 0
    
    var isViaBooking:Bool = Bool()
    var parentView = BookingController()
    var parentPreview = BookingPreviewController()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setData(booking:Tickets, isViaBooking:Bool) {
        self.isViaBooking = isViaBooking
        self.selectedBooking = booking
        //self.itemPriseLabel.text =  "$ \(booking.price ?? 0)"
        self.valueLabel.text = "\(booking.currentQuantity ?? 0)"
    }
    
    
    @IBAction func subtractAction(_ sender: Any) {
        
        if(isViaBooking){
        
        if(AppDelegate.sharedDelegate.previousCell == nil){
            AppDelegate.sharedDelegate.previousCell = self
        }else{
            if(AppDelegate.sharedDelegate.previousCell != self){
                AppDelegate.sharedDelegate.previousCell.valueLabel.text = "0"
                //STORYBOARD.KAppDelegate.previousCell.itemPriseLabel.text = "$ 0"
                AppDelegate.sharedDelegate.previousCell.selectedBooking?.currentQuantity = 0
                AppDelegate.sharedDelegate.previousCell = self
               
                 AppManager.sharedInstance.showTopAlert(alertMessage: "You can book only one category of tickets in single session.")
               

            }
        }
        }
        
        var value = Int(self.valueLabel.text ?? "") ?? 0
        self.selectedBooking?.currentQuantity = value
        if value == 0 {
            return
        }
        else {
            if(selectedBooking?.category == "Number of Bottles"){
                
                if(value > self.selectedBooking!.freeBottles!){
                  
                    value -= 1
                    if isViaBooking{
                        self.parentView.setTotalTicketsCount(selectedTicketId: self.selectedBooking?._id ?? "", totalValue: value)
                    }else{
                        self.parentPreview.setTotalTicketsCount(selectedTicketId: self.selectedBooking?._id ?? "", totalValue: value)
                    }
                    self.valueLabel.text = "\(value)"
                    self.selectedBooking?.currentQuantity = value
                    self.delegate?.tableFooterData(price: Double(value * ( self.selectedBooking?.price ?? 0 )), index: indexNumber)
                    
                    if value == 0 {
                        value += 1
                    }
                    
                    var paidQuantity = value - self.selectedBooking!.freeBottles!
                    if(paidQuantity == 0){
                         paidQuantity += 1
                    }
                    
                   // let result = paidQuantity * ( self.selectedBooking?.price ?? 0 )
                    //self.itemPriseLabel.text = "$ \(result)"
                    
                }
                
            }else{
                value -= 1
                if isViaBooking{
                    self.parentView.setTotalTicketsCount(selectedTicketId: self.selectedBooking?._id ?? "", totalValue: value)
                }else{
                    self.parentPreview.setTotalTicketsCount(selectedTicketId: self.selectedBooking?._id ?? "", totalValue: value)
                }
                self.valueLabel.text = "\(value)"
                self.selectedBooking?.currentQuantity = value
                self.delegate?.tableFooterData(price: Double(value * ( self.selectedBooking?.price ?? 0 )), index: indexNumber)
                if value == 0 {
                    value += 1
                }
                //let result = value * ( self.selectedBooking?.price ?? 0 )
                //self.itemPriseLabel.text = "$ \(result)"

            }
            
            
        }
    }
    
    @IBAction func addAction(_ sender: Any) {
        
        if(isViaBooking){
        
            if(AppDelegate.sharedDelegate.previousCell == nil){
            AppDelegate.sharedDelegate.previousCell = self
        }else{
            if(AppDelegate.sharedDelegate.previousCell != self){
                AppDelegate.sharedDelegate.previousCell.valueLabel.text = "0"
               // STORYBOARD.KAppDelegate.previousCell.itemPriseLabel.text = "$ 0"
                AppDelegate.sharedDelegate.previousCell.selectedBooking?.currentQuantity = 0
                AppDelegate.sharedDelegate.previousCell = self
                 AppManager.sharedInstance.showTopAlert(alertMessage: "You can book only one category of tickets in single session.")

                }
            }
        }
        
        var value = Int(self.valueLabel.text ?? "") ?? 0
        self.selectedBooking?.currentQuantity = value
        
        if value == self.selectedBooking?.remaining {
            AppManager.sharedInstance.showTopAlert(alertMessage: "Only \(selectedBooking!.remaining!) tickets are left for \(selectedBooking!.category!)")
            return
        }
        else {
            
            if(selectedBooking?.category == "Number of Bottles"){
                
                value += 1
                if isViaBooking{
                    self.parentView.setTotalTicketsCount(selectedTicketId: self.selectedBooking?._id ?? "", totalValue: value)
                }else{
                    self.parentPreview.setTotalTicketsCount(selectedTicketId: self.selectedBooking?._id ?? "", totalValue: value)
                }
                self.valueLabel.text = "\(value)"
                self.selectedBooking?.currentQuantity = value
                
                let paidQuantity = value - self.selectedBooking!.freeBottles!
                let result = paidQuantity * ( self.selectedBooking?.price ?? 0 )
                //self.itemPriseLabel.text = "$ \(result)"
                self.delegate?.tableFooterData(price: Double(result), index: indexNumber)
                
            }else{
                if(value < selectedBooking!.maxTicketPerUser!){
                    
                    if(value < selectedBooking!.remaining!){
                        value += 1
                        if isViaBooking{
                            self.parentView.setTotalTicketsCount(selectedTicketId: self.selectedBooking?._id ?? "", totalValue: value)
                        }else{
                            self.parentPreview.setTotalTicketsCount(selectedTicketId: self.selectedBooking?._id ?? "", totalValue: value)
                        }
                        self.valueLabel.text = "\(value)"
                        self.selectedBooking?.currentQuantity = value
                        let result = value * ( self.selectedBooking?.price ?? 0 )
                        //self.itemPriseLabel.text = "$ \(result)"
                        self.delegate?.tableFooterData(price: Double(result), index: indexNumber)
                        
                    }else{
                         AppManager.sharedInstance.showTopAlert(alertMessage: "Only \(selectedBooking!.remaining!) tickets are left for \(selectedBooking!.category!)")
                         
                    }

                }else{
                     AppManager.sharedInstance.showTopAlert(alertMessage: "Maximum allowed tickes for \(selectedBooking!.category!) is \(selectedBooking!.maxTicketPerUser!)")
                    
                }

            }
        }
    }
    
}
