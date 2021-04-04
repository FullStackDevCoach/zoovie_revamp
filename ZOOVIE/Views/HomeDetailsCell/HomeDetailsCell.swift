//
//  HomeDetailsCell.swift
//  ZOOVIE
//
//  Created by abc on 14/05/20.
//  Copyright © 2020 ZOOVIE. All rights reserved.
//

import UIKit

class HomeDetailsCell: UITableViewCell {

    @IBOutlet weak var btnTickets: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!{
        didSet{
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.register(UINib(nibName: "ConnectCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ConnectCollectionViewCell")
        }
    }
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var slotLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var lblAbout: UILabel!
    @IBOutlet weak var btnLike: UIButton!
    
    
    var parentView = HomeInnerController()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
extension HomeDetailsCell: UICollectionViewDataSource, UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.parentView.arrayArtist?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       let cell = collectionView
        .dequeueReusableCell(withReuseIdentifier: "ConnectCollectionViewCell", for: indexPath) as! ConnectCollectionViewCell
        // Configure the cell
        cell.lblName.text = "\(self.parentView.arrayArtist?[indexPath.row].firstName ?? "") \(self.parentView.arrayArtist?[indexPath.row].lastName ?? "")"
        let imageUser = self.parentView.arrayArtist?[indexPath.row].image?.original ?? ""
        if imageUser.contains("http"){
            cell.imgUser.setImage(with: imageUser)
        }else{
            cell.imgUser.image = UIImage(named: "placeholder")
        }
        
        cell.btnConnect.addTarget(self, action: #selector(actionConnect(sender:)), for: .touchUpInside)
        cell.btnConnect.tag = indexPath.row
        switch self.parentView.arrayArtist?[indexPath.row].status {
        case 0:
            cell.btnConnect.setTitle("CONNECT", for: .normal)
            break;
        case 1:
            cell.btnConnect.setTitle("PENDING", for: .normal)
            break;
        case 2:
            cell.btnConnect.setTitle("CONNECTED", for: .normal)
            break;
        case 3:
            cell.btnConnect.setTitle("REJECTED", for: .normal)
            break;
        case -1:
            cell.btnConnect.setTitle("RESPONSE", for: .normal)
            break;
        default:
            break;
        }
        return cell
    }
    // MARK: - UICollectionViewDelegate protocol

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
        //self.parentView.openOtherProfile()
    }
    
    
    
}
// MARK: - Collection View Flow Layout Delegate
extension HomeDetailsCell : UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    return CGSize(width: 120, height: 130)
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 10
  }
}
extension HomeDetailsCell {
    
    @objc func actionConnect(sender: UIButton){
        self.parentView.showLoading()
        print(self.parentView.arrayArtist?[sender.tag].status ?? -2)
        if self.parentView.arrayArtist?[sender.tag].status == 0{
            self.connectApi(index: sender.tag, params: [APIKey.userId: self.parentView.arrayArtist?[sender.tag]._id ?? ""], method: .POST, status: 1)
        }else if self.parentView.arrayArtist?[sender.tag].status == -1{
            //for accept: status=1, for reject status=3.
            let alert = UIAlertController(title: "", message: "Response to the request?", preferredStyle: UIAlertController.Style.alert)

            alert.addAction(UIAlertAction(title: "Accept", style: .default, handler: { (action: UIAlertAction!) in
              self.connectApi(index: sender.tag, params: [APIKey.userId: self.parentView.arrayArtist?[sender.tag]._id ?? "", APIKey.status: 1], method: .PUT, status: 1)
              }))

            alert.addAction(UIAlertAction(title: "Decline", style: .cancel, handler: { (action: UIAlertAction!) in
                
                self.connectApi(index: sender.tag, params: [APIKey.userId: self.parentView.arrayArtist?[sender.tag]._id ?? "", APIKey.status: 3], method: .PUT, status: 3)
                
              }))

            self.parentView.present(alert, animated: true, completion: nil)
        }
        
    }
    func connectApi(index: Int, params: [String: Any], method: API.HttpMethod, status: Int){
        ApiHandler.call(apiName: Constant.API.CONNECT, params: params, httpMethod: method) { (isSucceeded, response, data) in
            
                print(response)
                self.parentView.hideLoading()
                if isSucceeded == true {
                     guard let data = data else { return }
                    do {
                    //let result = try JSONDecoder().decode(CitiesModel.self, from: data)
                       // self.parentView.showAlert(alertMessage: "Request")
                       self.parentView.arrayArtist?[index].status = status
                       self.collectionView.reloadItems(at: [IndexPath(row: index, section: 0)])
                    }catch{}
                } else {
                if let message = response["message"] as? String {
                    self.parentView.showAlert(alertMessage: message)
                }
            }
            
        }
    }
}
