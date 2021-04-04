//
//  VistitedPlacesController.swift
//  ZOOVIE
//
//  Created by abc on 18/05/20.
//  Copyright © 2020 Zoovie. All rights reserved.
//

import UIKit

class VistitedPlacesController: UIViewController {

    @IBOutlet weak var tableView: UITableView!{
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.tableFooterView = UIView()
            tableView.register(UINib(nibName: "VisitPlacesCell", bundle: nil), forCellReuseIdentifier: "VisitPlacesCell")
            
        }
    }
    
    var placeVisited : [Places]?
    var comments : [Reviews]?
    var idx = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
extension VistitedPlacesController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //if idx == 0{
            return placeVisited?.count ?? 0
        //}
        //return comments?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VisitPlacesCell", for: indexPath) as! VisitPlacesCell
        cell.lblName.text = placeVisited?[indexPath.row].clubId?.name
        cell.lblAddress.text = placeVisited?[indexPath.row].clubId?.address
        let imgPlaces = placeVisited?[indexPath.row].clubId?.images?.first?.original ?? ""
        if imgPlaces.contains("http"){
            cell.imgVenue.setImage(with: imgPlaces)
        }else{
            cell.imgVenue.image = UIImage(named: "placeholder")
        }
        return cell
       
    }
    // MARK: - UITableViewDelegate
   
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if idx == 0{
            return 100
        }
        return 60
    }
}
