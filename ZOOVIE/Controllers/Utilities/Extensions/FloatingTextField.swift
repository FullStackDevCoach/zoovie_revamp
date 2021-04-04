//
//  FloatingTextField.swift
//  CullintonsCustomer
//
//  Created by Rakesh Kumar on 01/04/18.
//  Copyright © 2018 Rakesh Kumar. All rights reserved.
//

import UIKit

 @objc protocol FloatingTextFieldDelegate {
    @objc optional func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    @objc optional func textFieldShouldEndEditing(_ textField: UITextField) -> Bool
    @objc optional func textFieldDidChange(_textField:UITextField, updatedText:String)
    @objc optional func textFieldshouldChangeCharacters(_textField:UITextField, updatedText:String, newCharacter:String) -> Bool
}

class FloatingTextField: UITextField {

    var placeHolderLabel:UILabel?
    var floatingDelegate:FloatingTextFieldDelegate?
    var bottomLine:UIView?
    var isEyeButtonAvailable:Bool = false
    var bottomLineHeight:CGFloat = 1.0
    var bottomLineColor:UIColor = UIColor.white
    var placeholderPointY:CGFloat = 30.0
    var lineTranslationPoint:CGFloat = 0.0
    
    func setPlaceholder(placeholder:String, color:UIColor, font:UIFont, isSecure:Bool) {
        self.placeHolderLabel?.text = placeholder
        self.placeHolderLabel?.textColor = color
        self.placeHolderLabel?.font = font
        self.tintColor = color
        self.isSecureTextEntry = isSecure
        if isSecure == true && isEyeButtonAvailable == true  {
            self.addShowPasswordOption()
        }
    }
    
    func setBottomLineColor(color:UIColor) {
        self.bottomLineColor = color
        self.bottomLine?.backgroundColor = self.bottomLineColor
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.delegate = self
        self.placeHolderLabel = UILabel(frame:CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        self.addSubview(placeHolderLabel!)
        
        self.bottomLine = UIView(frame: CGRect(x: 0, y: self.frame.height, width: self.frame.width, height: bottomLineHeight))
        self.bottomLine?.backgroundColor = self.bottomLineColor
        self.addSubview(bottomLine!)
        
    }
    
    func addShowPasswordOption() {
        let eyeButton = UIButton(frame: CGRect(x: 0, y: self.frame.height, width: 40, height: 40))
        eyeButton.setImage(#imageLiteral(resourceName: "ic_password"), for: .normal)
        eyeButton.setImage(#imageLiteral(resourceName: "ic_password2"), for: .selected)
        eyeButton.addTarget(self, action: #selector(self.showPasswordAction(sender:)), for: .touchUpInside)
        self.rightView = eyeButton
        self.rightViewMode = .always
    }
    
    @objc func showPasswordAction(sender:UIButton) {
        sender.isSelected = !sender.isSelected
        self.isSecureTextEntry = !sender.isSelected
    }
    
    func checkToTranslatePlaceholder(text:String) {
        if text.count > 0 {
            self.tranlatePlaceholderLabel(status: true)
        }else{
            self.tranlatePlaceholderLabel(status: false)
        }
    }
    
    func tranlatePlaceholderLabel(status:Bool) {
        if status == true {
            if self.placeHolderLabel?.transform.ty == 0 {
                UIView.animate(withDuration: 0.2, animations: {
                    self.placeHolderLabel?.transform = CGAffineTransform(translationX: 0, y: -self.placeholderPointY)
                    self.transform = CGAffineTransform(translationX: 0, y: self.lineTranslationPoint)
                })
            }
        } else {
            if self.placeHolderLabel?.transform.ty != 0 {
                UIView.animate(withDuration: 0.2, animations: {
                    self.placeHolderLabel?.transform = CGAffineTransform.identity
                    self.transform = CGAffineTransform.identity
                }, completion: { finished in
                })
            }
        }
    }
}

extension FloatingTextField:UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.checkToTranslatePlaceholder(text: textField.text!)
        return floatingDelegate?.textFieldShouldBeginEditing?(textField) ?? true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        self.checkToTranslatePlaceholder(text: textField.text!)
        return floatingDelegate?.textFieldShouldEndEditing?(textField) ?? true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let updatedText = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        self.checkToTranslatePlaceholder(text: updatedText)
        floatingDelegate?.textFieldDidChange?(_textField: textField, updatedText: updatedText)
        return floatingDelegate?.textFieldshouldChangeCharacters?(_textField: textField, updatedText: updatedText, newCharacter:string) ?? true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        floatingDelegate?.textFieldDidChange?(_textField: textField, updatedText: textField.text!)
    }
    
    
    
    
    
}
