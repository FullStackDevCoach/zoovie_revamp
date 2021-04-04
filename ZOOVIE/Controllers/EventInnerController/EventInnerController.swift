//
//  EventInnerController.swift
//  ZOOVIE
//
//  Created by abc on 18/05/20.
//  Copyright © 2020 Zoovie. All rights reserved.
//

import UIKit

class EventInnerController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!{
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.register(UINib(nibName: "ConnectCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ConnectCollectionViewCell")
            
        }
    }
    @IBOutlet weak var lblAbout: UILabel!
    @IBOutlet weak var viewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var lblEventCity: UILabel!
    @IBOutlet weak var lblEventTime: UILabel!
    @IBOutlet weak var lblEventTitleName: UILabel!
    var eventData: Events?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configView()
    }
    func configView(){
        self.lblAbout.text = self.eventData?.about
        self.lblEventTime.text = self.eventData?.createdAt?.getDate()
        //self.lblEventCity.text = self.eventData?.city.uppercased()
        self.lblEventTitleName.text = self.eventData?.name
        let imageEvent =  self.eventData?.images?.first?.original ?? ""
        if imageEvent.contains("http"){
            eventImage.setImage(with: imageEvent)
        }else{
            eventImage.image = UIImage(named: "placeholder")
        }
        //Connections
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        viewHeightConstraint.constant = lblAbout.bounds.size.height - 50
    }
    @IBAction func actionTicket(_ sender: Any) {
        
    }
    
    @IBAction func actionShare(_ sender: Any) {
        AppManager.sharedInstance.shareAppUrl(view: self)
    }
    func openOtherProfile(){
        let vc = self.storyboard?.instantiateViewController(identifier: "OtherUserProfileController") as! OtherUserProfileController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension EventInnerController: UICollectionViewDataSource, UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       let cell = collectionView
          .dequeueReusableCell(withReuseIdentifier: "ConnectCollectionViewCell", for: indexPath)
        // Configure the cell
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
        self.openOtherProfile()
    }
    
    
}
// MARK: - Collection View Flow Layout Delegate
extension EventInnerController : UICollectionViewDelegateFlowLayout {
  
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
