//
//  HomeContainerController.swift
//  ZOOVIE
//
//  Created by abc on 12/05/20.
//  Copyright © 2020 Zoovie. All rights reserved.
//

import UIKit

class HomeContainerController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var btnHome: UIButton!
    @IBOutlet weak var btnEvent: UIButton!
    @IBOutlet weak var btnNotification: UIButton!
    @IBOutlet weak var btnProfile: UIButton!
    @IBOutlet weak var tabBar: DesignableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
       
          congifView()

    }
    private func congifView(){
        self.actionHomeTab(btnHome)
    }
    @IBAction func actionHomeTab(_ sender: UIButton) {
        setNavigationBarChat()
        guard let childVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeController") as? HomeController else {
                return
        }
        childVC.tabBarView = self.tabBar
        self.actionTabBarSelection(sender: sender, childVC: childVC)
    }
    @IBAction func actionEventTab(_ sender: UIButton) {
        setNavigationBarChat()
        guard let childVC = self.storyboard?.instantiateViewController(withIdentifier: "EventListController") as? EventListController else {
                return
        }
        self.actionTabBarSelection(sender: sender, childVC: childVC)
    }
    @IBAction func actionNotificationTab(_ sender: UIButton) {
        setNavigationBarChat()
        guard let childVC = self.storyboard?.instantiateViewController(withIdentifier: "NotificationListController") as? NotificationListController else {
                return
        }
        self.actionTabBarSelection(sender: sender, childVC: childVC)
    }
    @IBAction func actionProfileTab(_ sender: UIButton) {
        setNavigationBarSettings()
        guard let childVC = self.storyboard?.instantiateViewController(withIdentifier: "MyProfileController") as? MyProfileController else {
                return
        }
        self.actionTabBarSelection(sender: sender, childVC: childVC)
    }
    
    private func actionTabBarSelection(sender:UIButton, childVC: UIViewController){
        self.btnHome.isSelected = false
        self.btnEvent.isSelected = false
        self.btnNotification.isSelected = false
        self.btnProfile.isSelected = false
        sender.isSelected = true
        if self.children.count > 0{
            self.removeChildController(content: self.children[0])
        }
        self.addChild(childVC)
        childVC.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        childVC.view.frame = containerView.bounds
                   
        containerView.addSubview(childVC.view)
        childVC.didMove(toParent: self)
    }
    func removeChildController(content: UIViewController) {
        content.willMove(toParent: nil)
        content.view.removeFromSuperview()
        content.removeFromParent()
    }
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(true)
       //let image = UIImage(named: "logo")
        
    }
    func setNavigationBarChat(){
        self.setNavigationBarTitle(title: "ZOOVIE")
        let rightButton = UIBarButtonItem(image: UIImage(named: "chat-ic"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(actionChat))
        self.navigationItem.rightBarButtonItems = [rightButton]
        let backButton = UIBarButtonItem(title: "", style: .plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
    }
    func setNavigationBarSettings(){
        self.setNavigationBarTitle(title: "My Profile")
        let rightButton = UIBarButtonItem(image: UIImage(named: "setting-ic"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(actionSettings))
        self.navigationItem.rightBarButtonItems = [rightButton]
        let backButton = UIBarButtonItem(title: "", style: .plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
    }
    @objc func actionChat(){
        //self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func actionSettings(){
        let vc = self.storyboard?.instantiateViewController(identifier: "SettingsController") as! SettingsController
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
