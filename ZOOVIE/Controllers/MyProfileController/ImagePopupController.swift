//
//  ImagePopupController.swift
//  ZOOVIE
//
//  Created by abc on 07/06/20.
//  Copyright © 2020 Zoovie. All rights reserved.
//

import UIKit

class ImagePopupController: UIViewController {
    
    @IBOutlet weak var clubImage: UIImageView!
    
    var original:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.clubImage.transform = CGAffineTransform(scaleX: 0, y: 0)
        self.setIimage()
        self.setTapGesture()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.setAnimation()
    }
    
    func setAnimation() {
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 1.0, options: .curveLinear, animations: {
            self.clubImage.transform = CGAffineTransform.identity
        }, completion: nil)
    }
    
    
    func setIimage() {
        if self.original != "" {
            if let url = URL(string: self.original ?? "") {
                self.clubImage.kf.setImage(with: url)
            }
        }
    }

    func setTapGesture() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        self.view.addGestureRecognizer(gesture)
    }
    
    @objc func tapAction() {
        UIView.animate(withDuration: 0.2, animations: {
            self.clubImage.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        }) { finished in
            self.dismiss(animated: false, completion: nil)
        }
        
    }
}
