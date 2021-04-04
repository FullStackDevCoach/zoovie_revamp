//
//  PaymentController.swift
//  Zoovie
//
//  Created by MAC on 07/02/19.
//  Copyright © 2019 rakesh. All rights reserved.
//

import UIKit

class PaymentController: UIViewController {
    
    var transectionId:String = ""
    var isViaTransaction:Bool = Bool()
    
    @IBOutlet var backButton: UIButton!
    @IBOutlet var qrImage: UIImageView!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var transactionIDLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.shareButton.isHidden = true
        print("........transectionId now.........", transectionId)
        self.transactionIDLabel.text = transectionId
        qrImage.image = self.generateQRCode(from: transectionId)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if(isViaTransaction){
            self.navigationController?.navigationBar.isHidden = false
            self.backButton.isHidden = true


        }else{
            self.navigationController?.navigationBar.isHidden = true
            self.backButton.isHidden = false

        }
    }
    
    @IBAction func shareAction(_ sender: UIButton) {
        
    }
    
    @IBAction func homeAction(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)
            
            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }
        
        return nil
    }
    
}
