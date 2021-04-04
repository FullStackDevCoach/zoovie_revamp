//
//  OrderTicketController.swift
//  ZOOVIE
//
//  Created by abc on 19/05/20.
//  Copyright © 2020 Zoovie. All rights reserved.
//

import UIKit

protocol OrderControllerDelegate {
    func orderAction(bookingArray: [Tickets])
}

class OrderTicketController: UIViewController {

    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblQty: UILabel!
    @IBOutlet weak var viewBg: UIView!
    
    var total = 0
    var delegate:OrderControllerDelegate?
    var eventData:EventData?
    var bookingArray = [Tickets]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(self.bookingArray)
        // Do any additional setup after loading the view.
        viewBg.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(actionClose)))
    }
    @objc func actionClose(){
        self.dismiss(animated: false, completion: nil)
    }
    @IBAction func actionMinus(_ sender: Any) {
        if total != 0{
            total = total-1
            self.lblQty.text = "\(total)"
            self.bookingArray[0].currentQuantity = total
        }
    }
    @IBAction func actionPlus(_ sender: Any) {
        if total == self.bookingArray[0].remaining {
            AppManager.sharedInstance.showTopAlert(alertMessage: "Only \(bookingArray[0].remaining!) tickets are left for \(bookingArray[0].category!)")
                   return
        }else{
            total = total+1
            self.lblQty.text = "\(total)"
            self.bookingArray[0].currentQuantity = total
        }
    }
    
    @IBAction func actionOrderNow(_ sender: Any) {
        orderAction()
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
