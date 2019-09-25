//
//  MainTableViewController.swift
//  Rate Places
//
//  Created by Nadzieja on 19/09/2019.
//  Copyright © 2019 Nadzieja Siwucha. All rights reserved.
//

import UIKit
import CoreData

class MainTableViewController: UITableViewController {
    
    var fetchResultsController: NSFetchedResultsController<Place>!
    
    var placesArray: [Place] = []
    
//                        Place(name: "Vegano", position: "Krakow", type: "Restaurant", photo: nil, baseImage: "Vegano"),
//                        Place(name: "Zielona Kuchnia", position: "Krakow", type: "Restaurant", photo: nil, baseImage: "Zielona Kuchnia"),
//                        Place(name: "Garden Restaurant", position: "Krakow", type: "Restaurant", photo: nil, baseImage: "Garden Restaurant"),
//                        Place(name: "Pod Złotym Karpiem", position: "Krakow", type: "Restaurant", photo: nil, baseImage: "Pod Złotym Karpiem"),
//                        Place(name: "Youmiko Sushi", position: "Krakow", type: "Restaurant", photo: nil, baseImage: "Youmiko Sushi")
//    ]
//
    var cellHeight: CGFloat = 80
    

    
    @IBAction func unwindSegueSaveButton(_ segue: UIStoryboardSegue) {
        
        guard let newPlaceFromOtherVC = segue.source as? NewPlaceTableViewController else { return }
        // add new object to data array.
        newPlaceFromOtherVC.saveNewPlace()
        placesArray.append(newPlaceFromOtherVC.newPlace!)
        tableView.reloadData()
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        // fetch Request
        let fetchRequest: NSFetchRequest<Place> = Place.fetchRequest()
        let sortDescriptorPlace = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptorPlace] // применяем тут фильтр
        
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        }
        
        do {
            try fetchResultsController.performFetch()
            placesArray = fetchResultsController.fetchedObjects!
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        
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
        
        
        // могут быть изменения тут
        if currentPlace.photo == nil {
            cell.placePhoto.image = UIImage(named: currentPlace.baseImage!)
        } else {
            cell.placePhoto.image =  UIImage(data: currentPlace.photo!)  // преобразовываем attribute типа Data в UIImage
        }
        return cell
    }


    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let shareAction = UITableViewRowAction(style: .default, title: "Share") { (action, indexPath) in
            
            let shareText = "Now I'm in here. " + self.placesArray[indexPath.row].name!
            if let shareImage = UIImage(data: self.placesArray[indexPath.row].photo as! Data) {
                let activityController = UIActivityViewController(activityItems: [shareText, shareImage], applicationActivities: nil)
                self.present(activityController, animated: true, completion: nil)
            }
        }
        
        
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") { (action, indexPath) in
            
            self.placesArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
             if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
                
                let objectToDelete = self.fetchResultsController.object(at: indexPath)
                context.delete(objectToDelete)
                
                do {
                    try context.save()
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        
        shareAction.backgroundColor = UIColor.blue
        deleteAction.backgroundColor = UIColor.red

        return [shareAction, deleteAction]
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
