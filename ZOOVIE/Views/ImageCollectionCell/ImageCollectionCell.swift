//
//  ImageCollectionCell.swift
//  ZOOVIE
//
//  Created by abc on 18/05/20.
//  Copyright © 2020 Zoovie. All rights reserved.
//

import UIKit

class ImageCollectionCell: UICollectionViewCell {

    @IBOutlet weak var imageStory: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setData(){
        self.imageStory.layer.borderColor = Constants.Colors.APP_COLOR.cgColor
        self.imageStory.borderWidth = 1.0
    }
}
