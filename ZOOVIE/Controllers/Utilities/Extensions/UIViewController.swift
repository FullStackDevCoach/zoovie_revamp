//
//  UIViewController.swift
//  CAMELOT
//
//  Created by abc on 27/04/20.
//  Copyright © 2020 ZOOVIE. All rights reserved.
//

import UIKit
import MBProgressHUD

extension UIViewController {

    func setNavigationBarTitle(title: String){
        //Set Navigation Bar Title
        self.title = title
        //self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: Font.AppFont.bold.with(size: 18)]
        //Set Navigation Bar Tint Color
        self.navigationController?.navigationBar.tintColor = Constants.Colors.BLACK_COLOR
    }
    //Set Navigation Back Button
    func setLeftBackButton() {
        let leftButton = UIBarButtonItem(image: UIImage(named: "back-ic"), style: UIBarButtonItem.Style.plain , target: self, action: #selector(actionBack))
        navigationItem.leftBarButtonItems = [leftButton]
   }
    //Set Navigation Back Action
    @objc func actionBack(){
        self.navigationController?.popViewController(animated: true)
    }
    //Simple Alert
    func showAlert(alertText : String = "Alert", alertMessage : String) {
        let alert = UIAlertController(title: alertText, message: alertMessage, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        //Add more actions as you see fit
        self.present(alert, animated: true, completion: nil)
    }
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func showLoading() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
    }
       
    func hideLoading() {
        MBProgressHUD.hide(for: self.view, animated: true)
    }
}
