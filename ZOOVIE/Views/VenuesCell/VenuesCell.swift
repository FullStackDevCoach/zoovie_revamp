//
//  VenuesCell.swift
//  ZOOVIE
//
//  Created by abc on 12/05/20.
//  Copyright © 2020 Zoovie. All rights reserved.
//

import UIKit

class VenuesCell: UITableViewCell {

    @IBOutlet weak var imgVenue: UIImageView!
    @IBOutlet weak var venueName: UILabel!
    @IBOutlet weak var venueAddress: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
