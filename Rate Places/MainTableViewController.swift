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
    
    var editIndexPath: IndexPath?
    
    @IBAction func unwindSegueSaveButton(_ segue: UIStoryboardSegue) {
        
        guard let newPlaceFromOtherVC = segue.source as? NewPlaceTableViewController else { return }
        
        if editIndexPath != nil {
            deletePlace(indexPath: editIndexPath!)
            editIndexPath = nil
        }

            newPlaceFromOtherVC.savePlace()
            downloadCoreData()
            tableView.reloadData()
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
       
         downloadCoreData()
        
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
            cell.placePhoto.image =  UIImage(data: currentPlace.photo!)
        }
        return cell
    }


    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let shareAction = UITableViewRowAction(style: .default, title: "Share") { (action, indexPath) in
            
            let shareText = "Now I'm in here. " + self.placesArray[indexPath.row].name!
            if let shareImage = UIImage(data: (self.placesArray[indexPath.row].photo as! Data)) {
                let activityController = UIActivityViewController(activityItems: [shareText, shareImage], applicationActivities: nil)
                self.present(activityController, animated: true, completion: nil)
            }
        }
        
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") { (action, indexPath) in
            
            self.deletePlace(indexPath: indexPath)
        }
        
        shareAction.backgroundColor = UIColor.blue
        deleteAction.backgroundColor = UIColor.red

        return [shareAction, deleteAction]
    }
    
    

    func addExampleItem() {
        
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            
            let initialPlace = Place(context: context)
            initialPlace.name = "Zielona Kuchnia"
            initialPlace.position = "Krakow"
            initialPlace.type = "Restaurant"
            initialPlace.photo = UIImage(named: "Zielona Kuchnia")?.pngData()
            initialPlace.baseImage = nil

            do {
                try context.save()
                placesArray.append(initialPlace)
            } catch let error as NSError {
                print("Saving failed! \(error), \(error.userInfo)")
            }
            
        }
    }
    
    // MARK: - Delete Data
    
    func deletePlace(indexPath: IndexPath) {
        
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
    
    // MARK: - Download Data
    
    func downloadCoreData() {
        
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
            
            if placesArray == [] {
                addExampleItem()
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
    }
    
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "editInformation" {
            
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
           
            editIndexPath = indexPath
           
            let selectedPlace = placesArray[indexPath.row]
            
            let newPlaceTVC = segue.destination as! NewPlaceTableViewController
            newPlaceTVC.editedPlace = selectedPlace
 

        }

    }
    
    

}
