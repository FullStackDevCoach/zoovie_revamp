//
//  AlertController.swift
//  ZOOVIE
//
//  Created by SFS on 26/05/20.
//  Copyright © 2020 Zoovie. All rights reserved.
//

import Foundation
import UIKit

enum AlertAction:String {
    case Ok
    case nCancel
    case Cancel
    case Delete
    case Yes
    case No
    
    var title:String {
        switch self {
        case .nCancel:
            return "Cancel"
        default:
            return self.rawValue
        }
    }
    
    var style: UIAlertAction.Style {
        switch self {
        case .Cancel:
            return .cancel
        case .Delete:
            return .destructive
        default:
            return .default
        }
    }
}

enum AlertInputType:Int {
    case normal
    case email
    case password
}

typealias AlertHandler = (_ action:AlertAction) -> Void

extension UIAlertController {
    class func showAlert(withTitle title: String?, message: String?) {
        showAlert(title: title, message: message, preferredStyle: .cancel, sender: nil, actions: .Ok, handler: nil)
    }
    class func showAlert(title:String?, message:String?, preferredStyle: UIAlertAction.Style, sender: AnyObject?, target:UIViewController? = UIApplication.topViewController(), actions:AlertAction..., handler:AlertHandler?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for arg in actions {
            let action = UIAlertAction(title: arg.title, style: arg.style, handler: { (action) in
                handler?(arg)
            })
            alertController.addAction(action)
        }
        if let presenter = alertController.popoverPresentationController {
            presenter.sourceView = target?.view;
            presenter.permittedArrowDirections = .any
            presenter.sourceRect = sender?.bounds ?? .zero
        }
        target?.present(alertController, animated: true, completion: nil)
        
    }
    
    class func showInputAlert(title:String?, message:String?, inputPlaceholders:[String]?, preferredStyle: UIAlertAction.Style, sender: AnyObject?, target:UIViewController?, actions:AlertAction..., handler:AlertHandler?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for placeholder in inputPlaceholders ?? [] {
            alertController.addTextField(configurationHandler: { (txtField) in
                txtField.placeholder = placeholder
            })
        }
        for arg in actions {
            let action = UIAlertAction(title: arg.title, style: arg.style, handler: { (action) in
                handler?(arg)
            })
            alertController.addAction(action)
        }
        if let presenter = alertController.popoverPresentationController {
            presenter.sourceView = target?.view
            presenter.permittedArrowDirections = .any
            presenter.sourceRect =  sender?.bounds ?? .zero
        }
        target?.present(alertController, animated: true, completion: nil)
    }
    
}


extension UIApplication {
    class func topViewController(_ controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navController = controller as? UINavigationController {
            return topViewController(navController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(presented)
        }
        //        if let slide = controller as? SlideMenuController {
        //            return topViewController(slide.mainViewController)
        //        }
        return controller
    }
}
