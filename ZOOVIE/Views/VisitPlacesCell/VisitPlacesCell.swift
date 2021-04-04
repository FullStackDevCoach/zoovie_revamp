//
//  VisitPlacesCell.swift
//  MailApp
//
//  Created by abc on 18/05/20.
//  Copyright © 2020 mailapp. All rights reserved.
//

import UIKit

class VisitPlacesCell: UITableViewCell {

    @IBOutlet weak var imgVenue: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
