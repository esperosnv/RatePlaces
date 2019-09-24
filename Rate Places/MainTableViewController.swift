//
//  MainTableViewController.swift
//  Rate Places
//
//  Created by Nadzieja on 19/09/2019.
//  Copyright © 2019 Nadzieja Siwucha. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController {
    
    
    var placesArray = [
                        Place(name: "Vegano", position: "Krakow", type: "Restaurant", photo: nil, baseImage: "Vegano"),
                        Place(name: "Zielona Kuchnia", position: "Krakow", type: "Restaurant", photo: nil, baseImage: "Zielona Kuchnia"),
                        Place(name: "Garden Restaurant", position: "Krakow", type: "Restaurant", photo: nil, baseImage: "Garden Restaurant"),
                        Place(name: "Pod Złotym Karpiem", position: "Krakow", type: "Restaurant", photo: nil, baseImage: "Pod Złotym Karpiem"),
                        Place(name: "Youmiko Sushi", position: "Krakow", type: "Restaurant", photo: nil, baseImage: "Youmiko Sushi")
    ]
    var cellHeight: CGFloat = 80
    

    
    @IBAction func unwindSegueSaveButton(_ segue: UIStoryboardSegue) {
        
        guard let newPlaceFromOtherVC = segue.source as? NewPlaceTableViewController else { return }
        // add new object to data array.
        placesArray.append(newPlaceFromOtherVC.saveNewPlace())
        
        tableView.reloadData()
    }
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
       
         tableView.tableFooterView = UIView()
    
    }
    


    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return placesArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DescriptionCell", for: indexPath) as!  CustomTableViewCell
        
        let currentPlace = placesArray[indexPath.row]
        cell.nameLabel.text = currentPlace.name
        cell.positionLabel.text = currentPlace.position
        cell.typeLabel.text = currentPlace.type
        
        if currentPlace.photo == nil {
            cell.placePhoto.image = UIImage(named: currentPlace.baseImage!)
        } else {
            cell.placePhoto.image = currentPlace.photo
        }

        


        return cell
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
