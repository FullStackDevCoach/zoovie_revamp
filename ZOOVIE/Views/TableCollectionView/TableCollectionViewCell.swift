//
//  TableCollectionViewCell.swift
//  ZOOVIE
//
//  Created by abc on 14/05/20.
//  Copyright © 2020 Zoovie. All rights reserved.
//

import UIKit

class TableCollectionViewCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!{
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.register(UINib(nibName: "TicketsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TicketsCollectionViewCell")
            
        }
    }
    var parentView = NotificationListController()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
extension TableCollectionViewCell: UICollectionViewDataSource, UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.parentView.notificationData?.tickets?.count ?? 0 > 4{
            return 4
        }
        return self.parentView.notificationData?.tickets?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       let cell = collectionView
          .dequeueReusableCell(withReuseIdentifier: "TicketsCollectionViewCell", for: indexPath) as! TicketsCollectionViewCell
        // Configure the cell
        cell.lblName.text = self.parentView.notificationData?.tickets?.reversed()[indexPath.row].category
        let imageUser =  self.parentView.notificationData?.tickets?.reversed()[indexPath.row].category
        if imageUser?.contains("http") ?? false{
            cell.imgTicket.setImage(with: imageUser!)
        }else{
            //cell.imgTicket.image = UIImage(named: "placeholder")
        }
        return cell
    }
    
    
    
}
// MARK: - Collection View Flow Layout Delegate
extension TableCollectionViewCell : UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    return CGSize(width: 150, height: 220)
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
  }
  
  // 4
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 10
  }
}
