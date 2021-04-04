//
//  NotificationHeaderCell.swift
//  ZOOVIE
//
//  Created by abc on 13/05/20.
//  Copyright © 2020 Zoovie. All rights reserved.
//

import UIKit

class NotificationHeaderCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnSeeAll: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
