//
//  SettingsCell.swift
//  CAMELOT
//
//  Created by Ankush on 23/04/20.
//  Copyright © 2020 CAMELOT. All rights reserved.
//

import UIKit

class SettingsCell: UITableViewCell {

    //MARK:- Outlets
    @IBOutlet weak var iconSettingOptions: UIImageView!
    @IBOutlet weak var lblSettingTitle: UILabel!
    
    //MARK:- Variables
    let arrSettingOptions = ["Privacy Policy", "Terms and Conditions", "Logout"];
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        self.layoutMargins = .zero
    }
    
    func setData(index: Int){
        self.lblSettingTitle.text = arrSettingOptions[index]
        //self.iconSettingOptions.image = UIImage(named: arrSettingOptions[index])
    }
   
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
