//
//  TextField.swift
//  TestApp
//
//  Created by abc on 14/05/20.
//  Copyright © 2020 abc. All rights reserved.
//

import UIKit

class TextField: UITextField {
  
    let border =  CALayer()

    @IBInspectable var leftImage: UIImage? {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var rightImage: UIImage? {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var padding = UIEdgeInsets(top: 0, left: 23, bottom: 0, right: 5)
   
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
        override open func textRect(forBounds bounds: CGRect) -> CGRect {
            return bounds.inset(by: padding)
        }
        
        override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
            return bounds.inset(by: padding)
        }
        
        override open func editingRect(forBounds bounds: CGRect) -> CGRect {
            return bounds.inset(by: padding)
        }
        
    @IBInspectable var color: UIColor = UIColor.lightGray {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var underLineColor: UIColor = UIColor.lightGray {
        didSet {
            updateView()
        }
    }
    @IBInspectable var bordercolor: UIColor = UIColor.lightGray {
        didSet {
          borderColorMethod()
        }
    }
    deinit {
        
        
    }
    
    func updateView() {
  
        if let image = leftImage {
            leftViewMode = UITextField.ViewMode.always
            let viewLeft:  UIView=UIView(frame: CGRect(x: 5, y: 0, width: 15,height: 15))
            let imageView = UIImageView(frame: CGRect(x:5, y: 0, width: 15, height: 15))
            imageView.image = image
           imageView.contentMode = .scaleAspectFit
            // Note: In order for your image to use the tint color, you have to select the image in the Assets.xcassets and change the "Render As" property to "Template Image".
            imageView.tintColor = color
            viewLeft.addSubview(imageView)
            leftView = viewLeft
            
            
        } else {
            leftViewMode = UITextField.ViewMode.always
            let viewLeft:  UIView=UIView(frame: CGRect(x: 0, y: 0, width: 10,height: 20))
            viewLeft.backgroundColor = .clear
            leftView = viewLeft
            
        }
        
        if let _ = rightImage {
            rightViewMode = UITextField.ViewMode.always
            let viewLeft:  UIView=UIView(frame: CGRect(x: 0, y: 0, width: 60,height: 20))
            let imageView = UIImageView(frame: CGRect(x: 0, y: -2, width: 20, height: 20))
            //imageView.image = image
            // Note: In order for your image to use the tint color, you have to select the image in the Assets.xcassets and change the "Render As" property to "Template Image".
            imageView.tintColor = color
            viewLeft.addSubview(imageView)
            rightView = viewLeft
            
            
        }
        let width = CGFloat(1.0)
        border.borderColor = underLineColor.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
        
        border.borderWidth = width
       // self.layer.addSublayer(border)
        self.layer.masksToBounds = true
        // Placeholder text color
        attributedPlaceholder = NSAttributedString(string: placeholder != nil ?  placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: color])
    }
    

      func borderColorMethod(){
        leftViewMode = UITextField.ViewMode.always
        let viewLeft:  UIView=UIView(frame: CGRect(x: 0, y: 0, width: 40,height: 20))
        leftView = viewLeft
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.layer.cornerRadius = self.frame.height/2
            
        }
       
        self.layer.borderColor = bordercolor.cgColor
        self.layer.borderWidth = 1
        self.layer.masksToBounds = true

    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (keyPath == "self.bounds") {
            
            if let image = leftImage {
                leftViewMode = UITextField.ViewMode.always
                let viewLeft:  UIView=UIView(frame: CGRect(x: 0, y: 0, width: 30,height: 30))
                let imageView = UIImageView(frame: CGRect(x: 0, y: -2, width: 30, height: 30))
                imageView.image = image
                imageView.tintColor = color
       
                leftView = viewLeft
                
                
            } else {
                leftViewMode = UITextField.ViewMode.always
                let viewLeft:  UIView=UIView(frame: CGRect(x: 0, y: 0, width: 10,height: 20))
                viewLeft.backgroundColor = .clear
                leftView = viewLeft

            }
            
            if let _ = rightImage {
                rightViewMode = UITextField.ViewMode.always
                let viewLeft:  UIView=UIView(frame: CGRect(x: 0, y: 0, width: 60,height: 20))
                let imageView = UIImageView(frame: CGRect(x: 0, y: -2, width: 20, height: 20))
                //imageView.image = image
                // Note: In order for your image to use the tint color, you have to select the image in the Assets.xcassets and change the "Render As" property to "Template Image".
                imageView.tintColor = color
                viewLeft.addSubview(imageView)
                rightView = viewLeft
                
                
            }
            let width = CGFloat(1.0)
            border.borderColor = underLineColor.cgColor
            border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
            
            border.borderWidth = width
            self.layer.addSublayer(border)
            self.layer.masksToBounds = true
            // Placeholder text color
            attributedPlaceholder = NSAttributedString(string: placeholder != nil ?  placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: color])
            return
        }
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
