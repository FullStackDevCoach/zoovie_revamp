//
//  SettingsController.swift
//  ZOOVIE
//
//  Created by SFS on 08/06/20.
//  Copyright © 2020 Zoovie. All rights reserved.
//

import UIKit

class SettingsController: UIViewController {

    //MARK:- Outlets
    @IBOutlet weak var tableView: UITableView!{
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.register(UINib(nibName: "SettingsCell", bundle: nil), forCellReuseIdentifier: "SettingsCell")
            tableView.tableFooterView = UIView()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.setNavigationBarTitle(title: "SETTINGS")
        self.setLeftBackButton()
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
//MARK:- UITableViewDataSource
extension SettingsController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: String.init(describing: SettingsCell.self), for: indexPath) as! SettingsCell
            cell.setData(index: indexPath.row)
            return cell
    }
   
    //MARK:- UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
          //let vc = self.storyboard?.instantiateViewController(identifier: "")
          //self.navigationController?.pushViewController(vc, animated: true)
            break;
        case 1:
           
               
            break;
        case 2:
             //Logout
           // self.showLoading()
            AppDelegate.sharedDelegate.goToSplashVC()
            break;
        default:
            return
        }
    }
}
