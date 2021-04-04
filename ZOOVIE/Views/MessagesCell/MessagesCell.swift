//
//  MessagesCell.swift
//  ZOOVIE
//
//  Created by SFS on 13/05/20.
//  Copyright © 2020 Zoovie. All rights reserved.
//

import UIKit

class MessagesCell: UITableViewCell {

    //MARK:- Outlets
    @IBOutlet weak var imgItem: UIImageView!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var imgNotification: UIImageView!
    @IBOutlet weak var lblMessageTrainingConstraint: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setMessagesData(message: String){
        self.imgNotification.isHidden = true
        self.backgroundColor = Constants.Colors.WHITE_COLOR
        self.lblMessage.text = message
    }
    func setNotificationsData(message: String){
        self.imgNotification.isHidden = false
        self.backgroundColor = Constants.Colors.LIGHT_SEPRATOR_COLOR
        self.lblMessage.text = message
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
