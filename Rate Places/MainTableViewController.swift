//
//  MainTableViewController.swift
//  Rate Places
//
//  Created by Nadzieja on 19/09/2019.
//  Copyright © 2019 Nadzieja Siwucha. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController {
    
    
    let placeName = [
                    "Vegano", "Zielona Kuchnia", "Garden Restaurant", "Pod Złotym Karpiem", "Youmiko Sushi"
                    ]
    var cellHeight: CGFloat = 80

    override func viewDidLoad() {
        super.viewDidLoad()
       
    
    }
    


    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return placeName.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DescriptionCell", for: indexPath) as!  CustomTableViewCell
        
        cell.nameLabel.text = placeName[indexPath.row]
        cell.placePhoto.image = UIImage(named: placeName[indexPath.row])


        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
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
