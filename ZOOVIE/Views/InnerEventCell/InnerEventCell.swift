//
//  InnerEventCell.swift
//  ZOOVIE
//
//  Created by abc on 13/05/20.
//  Copyright © 2020 Zoovie. All rights reserved.
//

import UIKit

class InnerEventCell: UITableViewCell {

    @IBOutlet weak var imgItem: UIImageView!
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var btnComment: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
