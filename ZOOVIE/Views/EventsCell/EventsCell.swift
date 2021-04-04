//
//  EventsCell.swift
//  ZOOVIE
//
//  Created by abc on 13/05/20.
//  Copyright © 2020 Zoovie. All rights reserved.
//

import UIKit

class EventsCell: UITableViewCell {

    @IBOutlet weak var lblHashTag: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var imgVenue: UIImageView!
    @IBOutlet weak var lblTotalSlots: UILabel!
    @IBOutlet weak var imgUser: DesignableImage!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var btnTickets: UIButton!
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var btnComments: UIButton!
    @IBOutlet weak var lblAbout: ExpandableLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
