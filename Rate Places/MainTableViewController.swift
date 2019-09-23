//
//  MainTableViewController.swift
//  Rate Places
//
//  Created by Nadzieja on 19/09/2019.
//  Copyright © 2019 Nadzieja Siwucha. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController {
    
    
    let placesArray = [
                        Place(name: "Vegano", position: "Krakow", type: "Restaurant", photo: "Vegano"),
                        Place(name: "Zielona Kuchnia", position: "Krakow", type: "Restaurant", photo: "Zielona Kuchnia"),
                        Place(name: "Garden Restaurant", position: "Krakow", type: "Restaurant", photo: "Garden Restaurant"),
                        Place(name: "Pod Złotym Karpiem", position: "Krakow", type: "Restaurant", photo: "Pod Złotym Karpiem"),
                        Place(name: "Youmiko Sushi", position: "Krakow", type: "Restaurant", photo: "Youmiko Sushi")
    ]
    var cellHeight: CGFloat = 80
    
    @IBAction func cancelButtonAction(_ sender: UIStoryboardSegue) {}
    

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
        
        cell.nameLabel.text = placesArray[indexPath.row].name
        cell.positionLabel.text = placesArray[indexPath.row].position
        cell.typeLabel.text = placesArray[indexPath.row].type
        cell.placePhoto.image = UIImage(named: placesArray[indexPath.row].photo)


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
