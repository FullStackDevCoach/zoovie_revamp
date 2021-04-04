//
//  BookingPreviewController.swift
//  Zoovie
//
//  Created by MAC on 27/02/19.
//  Copyright © 2019 rakesh. All rights reserved.
//

import UIKit
import Stripe
import PassKit

class BookingPreviewController: UIViewController {
    
    @IBOutlet weak var bookingPreviewTable: UITableView!
    
    //var countCell:Int?
    var eventData:EventData?
    var dateEvent:String = ""
    var bookingArray: [Tickets]?
    var newBookingArray = [Tickets]()
    //var vipPerson = ["General","VipGeneral","VipSelection"]
    var totalWorth:Double = 0
    var totalTAX:Double = 0
    //var cellCount:Int = 0
    var eventType = "offline"
    
    let footerView = UINib(nibName: "BookingPreviewFooter", bundle: nil).instantiate(withOwner: self, options: nil)[0] as? BookingPreviewFooter
    
    /*var payPalConfig = PayPalConfiguration()
    var environment:String = PayPalEnvironmentNoNetwork {
        willSet(newEnvironment) {
            if (newEnvironment != environment) {
                PayPalMobile.preconnect(withEnvironment: newEnvironment)
            }
        }
    }*/
    //MARK:- Apple Pay Variables
    let supportedPaymentNetworks = [PKPaymentNetwork.visa, PKPaymentNetwork.masterCard, PKPaymentNetwork.amex]
    // Add in any extra support payments.
    let applePayMerchantID = "merchant.com.Zoovie"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTable()
        self.setBookingArray()
        //self.setPaypal()
        self.setRightSwipeGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setLeftBackButton()
        self.setNavigationBarTitle(title: "Booking Preview")
    }
    
    func setRightSwipeGesture() {
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(backAction))
        rightSwipe.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(rightSwipe)
    }
    @objc func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    /*func setPaypal() {
        payPalConfig.acceptCreditCards = false
        payPalConfig.merchantName = "Zoovie"//Give your company name here.
        payPalConfig.merchantPrivacyPolicyURL = URL(string: "https://www.paypal.com/webapps/mpp/ua/privacy-full")
        payPalConfig.merchantUserAgreementURL = URL(string: "https://www.paypal.com/webapps/mpp/ua/useragreement-full")
        //This is the language in which your paypal sdk will be shown to users.
        payPalConfig.languageOrLocale = Locale.preferredLanguages[0]
        //Here you can set the shipping address. You can choose either the address associated with PayPal account or different address. We’ll use .both here.
        payPalConfig.payPalShippingAddressOption = .both;
    }
    
    func presentPaypal(totalQuantity: Int, totalPrice: String) {

        let shipping = NSDecimalNumber(string: "0")
        let tax = NSDecimalNumber(string: "0")
        let subtotal = NSDecimalNumber(string: totalPrice)
        let paymentDetails = PayPalPaymentDetails(subtotal: subtotal, withShipping: shipping, withTax: tax)
        print("Payment details")
        let total = subtotal.adding(shipping).adding(tax) //This is the total price including shipping and tax
        let payment = PayPalPayment(amount: total, currencyCode: "USD", shortDescription: "Zoovie", intent: .sale)
        print("Payment")
//        payment.items = items
        payment.paymentDetails = paymentDetails
        if (payment.processable) {
            print("Processable")
            let paymentViewController = PayPalPaymentViewController(payment: payment, configuration: payPalConfig, delegate: self)
            present(paymentViewController!, animated: true, completion: nil)
        }
        else {
            // This particular payment will always be processable. If, for
            // example, the amount was negative or the shortDescription was
            // empty, this payment wouldn’t be processable, and you’d want
            // to handle that here.
            print("Payment not processalbe: (payment)")
        }
    }*/
    
    
    func setBookingArray() {
        guard let array = self.bookingArray else {return}
        for value in array {
            if (value.currentQuantity ?? 0) > 0 {
                self.newBookingArray.append(value)
                totalWorth = totalWorth + Double((value.currentQuantity ?? 0) * (value.price ?? 0))
                if value.isSection! && self.eventType == "offline"{
                    let dic4 = Tickets(_id: "", category: "Number of Bottles", freeBottles: value.freeBottles, isRsvp: nil, isSection: false, maxGuest: nil, maxTicketPerUser: nil, price: value.pricePerBottle, pricePerBottle: value.pricePerBottle, quantity: nil, remaining: nil, currentQuantity: value.freeBottles)
                    //dic4.category = "Number of Bottles"
                    //dic4.currentQuantity = value.freeBottles
                   // dic4.freeBottles = value.freeBottles
                    //dic4.pricePerBottle = value.pricePerBottle
                    //dic4.price = value.pricePerBottle
                    //dic4.isSection = false

                    self.newBookingArray.append(dic4)
                }
            }
        }
        print(newBookingArray)
        self.setTableFooter(price: totalWorth)
        self.bookingPreviewTable.reloadData()
    }
    
    func setTable() {
        self.bookingPreviewTable.delegate = self
        self.bookingPreviewTable.dataSource = self
        self.bookingPreviewTable.register(UINib(nibName: "BookingTableCell", bundle: nil), forCellReuseIdentifier: "BookingTableCell")
        self.setTableHeader()
        self.setTableFooter(price: totalWorth)
        self.bookingPreviewTable.reloadData()
    }
    
    func setTableHeader() {
        let headerView = UINib(nibName: "BookingPreviewHeader", bundle: nil).instantiate(withOwner: self, options: nil)[0] as? BookingPreviewHeader
        headerView?.frame = CGRect(x: 0, y: 0, width: Constants.Screen.width, height: 180)
        headerView?.eventLabel.text = self.eventData?.name
        headerView?.placeLabel.text = self.eventData?.address
        if let image = self.eventData?.images?.first?.original {
            let url = URL(string: image)
            headerView?.clubEventImage.kf.setImage(with: url)
        }
        headerView?.timeLabel.text = self.dateEvent
        self.bookingPreviewTable.tableHeaderView = headerView
    }
    
    func setTableFooter(price: Double) {
        
        if( self.newBookingArray.count > 0){
            
            let value = self.newBookingArray[0]
            if value.isSection! {
                footerView?.numberOfGuestLbl.isHidden = false
                footerView?.guestLbl.isHidden = false
                footerView?.numberOfGuestLbl.text = "\(value.maxGuest! as Int)"
            }else{
                footerView?.numberOfGuestLbl.isHidden = true
                footerView?.guestLbl.isHidden = true
            }
            
        }else{
            
            footerView?.numberOfGuestLbl.isHidden = true
            footerView?.guestLbl.isHidden = true
        }
        footerView?.frame = CGRect(x: 0, y: 0, width: Constants.Screen.width, height: 250)
        footerView?.itemTotalLabel.text = "\(totalWorth)"
        let tex = totalWorth / 10
        totalTAX = tex
        footerView?.taxesAndChargesLabel.text = "\(tex)"
        footerView?.grandTotalLabel.text = "\(totalWorth + tex)"
        footerView?.payButton.addTarget(self, action: #selector(payAction), for: .touchUpInside)
        footerView?.btnApplePay.addTarget(self, action: #selector(actionApplePay), for: .touchUpInside)
        footerView?.btnApplePay.isHidden = !PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: supportedPaymentNetworks)
        self.bookingPreviewTable.tableFooterView = footerView
    }
    func setBookingNewArrayAndApi(transection: String) {
        guard let eventId = self.eventData?._id else {return}
        var json = [String:Any]()
        if(newBookingArray.count == 2){
            
            var bottelTicket:Tickets!
            var vipTicket:Tickets!
            
            let newValue = newBookingArray[0]
            if(newValue.category! == "Number of Bottles"){
                bottelTicket = newBookingArray[0]
            }else{
                bottelTicket = newBookingArray[1]
            }
            if(newValue.isSection! ){
                vipTicket = newBookingArray[0]
            }else{
                vipTicket = newBookingArray[1]
            }
            json["quantity"] = vipTicket.currentQuantity
            json["ticketCategory"] = vipTicket.category
            json["eventId"] = eventId
            json["eventType"] = self.eventType
            json["transaction_token"] = transection
            if eventType == "offline"{
                json["bottleCount"] = bottelTicket.currentQuantity
            }
            

        }else{
            
            let newValue = newBookingArray[0]
            json["quantity"] = newValue.currentQuantity
            json["ticketCategory"] = newValue.category
            json["eventId"] = eventId
            json["transaction_token"] = transection
            json["eventType"] = self.eventType
            if eventType == "offline"{
                json["bottleCount"] = 0
            }
            
        }
        print(json)
        self.showLoading()
        ApiHandler.call(apiName: Constant.API.EVENT_BOOKING, params: json, httpMethod: .POST) { (isSucceeded, response, data) in
            DispatchQueue.main.async {
                self.hideLoading()
                print(isSucceeded)
                if isSucceeded == true {
                    print(response["bookingId"])
                    let controller = self.storyboard?.instantiateViewController(withIdentifier: "PaymentController") as! PaymentController
                    controller.transectionId = response["bookingId"] as? String ?? ""
                    self.navigationController?.pushViewController(controller, animated: true)

                } else {
                    if let message = response["message"] as? String {
                        self.showAlert(alertMessage: message)
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
            
        }
        
    }
    
    @objc func payAction() {
        var totalQuantity:Int = 0
        for thisArray in newBookingArray {
            if thisArray.category == "Number of Guests" {
                // nothing do here
            } else {
                if (thisArray.currentQuantity ?? 0) > 0 {
                    totalQuantity = totalQuantity + (thisArray.currentQuantity ?? 0)
                }
            }
        }
        let totalPrice = "\(footerView?.grandTotalLabel.text ?? "")"
        guard Double(totalPrice) != nil else {
            self.showAlert(alertMessage: "Invalid Amount")
            return
        }
        let ticket = newBookingArray[0]
        if(ticket.isRsvp!){
            self.setBookingNewArrayAndApi(transection: "FREE_ENTRY")
            
        }else{
            let addCardViewController = STPAddCardViewController()
            addCardViewController.delegate = self
            self.navigationController?.pushViewController(addCardViewController, animated: true)
            
            //self.setBookingNewArrayAndApi(transection: "FREE_ENTRY")
        }
      
    }
}

extension BookingPreviewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        return self.newBookingArray.count
      /*  if(newBookingArray.count > 0){
        let value = newBookingArray[0]
        if(value.isSection!){
            return 2
            
        }else{
          return  self.newBookingArray.count
        }
        }else{
           return 0
        } */
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookingTableCell") as? BookingTableCell
        cell?.itemPriseLabel.isHidden = true
        cell?.soldLbl.isHidden = true
        cell?.delegate = self
        cell?.parentPreview = self
        let data = newBookingArray[indexPath.row]
        cell?.setData(booking: data, isViaBooking: false)
        cell?.valueLabel.text = "\(data.currentQuantity ?? 0)"
        
        if(data.category == "Number of Bottles"){
            cell?.itemNameLabel.text = "\(data.category ?? "")\n(\(data.freeBottles!) complementary\nBuy more for $\(data.pricePerBottle!) each.)"

        }else{
            cell?.itemNameLabel.text = "\(data.category ?? "")"

        }
        cell?.indexNumber = indexPath.row

        return cell!
    }
    
}

extension BookingPreviewController: BookingTableCellDelegate {
    func tableFooterData(price: Double, index: Int) {
        totalWorth = 0
        print("delegate method")
        for value in newBookingArray {
            if (value.currentQuantity ?? 0) > 0 {
                if(value.category == "Number of Bottles"){
                    let newQuantity = value.currentQuantity! - value.freeBottles!
                    totalWorth = totalWorth + Double((newQuantity) * (value.price ?? 0))
                    
                }else{
                   totalWorth = totalWorth + Double((value.currentQuantity ?? 0) * (value.price ?? 0))
                }
                
            }
        }
        footerView?.itemTotalLabel.text = "\(totalWorth)"
        let tax = totalWorth / 10
        footerView?.taxesAndChargesLabel.text = "\(tax)"
        footerView?.grandTotalLabel.text = "\(totalWorth + tax)"
        DispatchQueue.main.async {
            //self.bookingPreviewTable.reloadData()
        }
        //
        self.totalTAX = tax
        print(tax)
        print(totalWorth)
    }
    func setTotalTicketsCount(selectedTicketId: String, totalValue: Int){
        for i in 0..<self.newBookingArray.count{
               if selectedTicketId == self.newBookingArray[i]._id{
                   self.newBookingArray[i].currentQuantity = totalValue
               }else{
                   self.newBookingArray[i].currentQuantity = 0
               }
           }
       }
    func reloadTable() {
    }
}

/*extension BookingPreviewController: PayPalPaymentDelegate {
    // PayPalPaymentDelegate
    func payPalPaymentDidCancel(_ paymentViewController: PayPalPaymentViewController) {
        print("PayPal Payment Cancelled")
        paymentViewController.dismiss(animated: true, completion: nil)
    }
    func payPalPaymentViewController(_ paymentViewController: PayPalPaymentViewController, didComplete completedPayment: PayPalPayment) {
        print("PayPal Payment Success !")
        paymentViewController.dismiss(animated: true, completion: { () -> Void in
            // send completed confirmaion to your server
            print("Here is your proof of payment:\(completedPayment.confirmation) Send this to your server for confirmation and fulfillment.")
            let result = completedPayment.confirmation as? [String:Any]
            let response = result?["response"] as? [String:Any]
//            print(response)
            let transactionId = response?["id"] as? String
            
            self.setBookingNewArrayAndApi(transection: "\(transactionId ?? "")")

        })
    }
}*/


extension BookingPreviewController: STPAddCardViewControllerDelegate {
    
    func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func addCardViewController(_ addCardViewController: STPAddCardViewController,
                               didCreateToken token: STPToken,
                               completion: @escaping STPErrorBlock) {
        self.setBookingNewArrayAndApi(transection: "\(token.tokenId)")
    }
}

extension BookingPreviewController: PKPaymentAuthorizationViewControllerDelegate {

    
    @objc func actionApplePay(){
        
        
        let request = PKPaymentRequest()
        request.merchantIdentifier = applePayMerchantID
        request.supportedNetworks = supportedPaymentNetworks
        request.merchantCapabilities = PKMerchantCapability.capability3DS
        request.countryCode = "US"
        request.currencyCode = "USD"
        
        //Item information formatting
        //let productToBuy = PKPaymentSummaryItem(label: "Ticket Price", amount: NSDecimalNumber(decimal:Decimal((totalWorth)/100)), type: .final)
        //let total = PKPaymentSummaryItem(label: "Total with Tax", amount: NSDecimalNumber(decimal:Decimal((totalTAX+totalWorth)/100)))
        //PKPaymentSummaryItem Array, we will be adding too.
        //request.paymentSummaryItems = [productToBuy,total]
        
        request.paymentSummaryItems = [
            PKPaymentSummaryItem(label: "Some Product", amount: 9.99)
        ]
        
        let applePayController = PKPaymentAuthorizationViewController(paymentRequest: request)
        applePayController?.delegate = self
        self.present(applePayController!, animated: true, completion: nil)
    }
    //Bottom of file
     func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
           controller.dismiss(animated: true, completion: nil)
       }
       func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
           completion(PKPaymentAuthorizationResult(status: PKPaymentAuthorizationStatus.success, errors: []))
       }
}
