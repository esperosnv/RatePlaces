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
    var filteredArray: [Place] = []
    
    var searchController: UISearchController!

    
    @IBAction func unwindSegueSaveButton(_ segue: UIStoryboardSegue) {
        
        guard let newPlaceFromOtherVC = segue.source as? NewPlaceTableViewController else { return }
        
            newPlaceFromOtherVC.savePlace()
            downloadCoreData()
            tableView.reloadData()
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        tableView.tableHeaderView = searchController.searchBar
       
        definesPresentationContext = true
        
        
        
         downloadCoreData()
         tableView.tableFooterView = UIView()
    
    }
    
    func displayPlaceAt(indexPath: IndexPath) -> Place {
        
        let currentPlace: Place
        
        if searchController.isActive && searchController.searchBar.text != "" {
            currentPlace = filteredArray[indexPath.row]
        } else {
            currentPlace = placesArray[indexPath.row]
        }
        return currentPlace
    }
    


    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredArray.count
        } else {
            return placesArray.count
        }
       
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DescriptionCell", for: indexPath) as!  CustomTableViewCell
        
        let currentPlace = displayPlaceAt(indexPath: indexPath)
        cell.nameLabel.text = currentPlace.name
        cell.positionLabel.text = currentPlace.position
        cell.typeLabel.text = currentPlace.type
        cell.cosmosVeiw.rating = currentPlace.rating
        
        if currentPlace.photo == nil {
            cell.placePhoto.image = UIImage(named: "Add Photo")
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
            initialPlace.rating = 5.0

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
           
            let selectedPlace = displayPlaceAt(indexPath: indexPath)

            let newPlaceTVC = segue.destination as! NewPlaceTableViewController
            newPlaceTVC.placeToEdit = selectedPlace
        }

    }
    
    func filterContent(searchText: String) {
        filteredArray = placesArray.filter{ (restaurant) -> Bool in
            return((restaurant.name?.lowercased().contains(searchText.lowercased()))!)
        }
    }
}

extension MainTableViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        filterContent(searchText: searchController.searchBar.text!)
        tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if searchBar.text != "" {
            navigationController?.hidesBarsOnSwipe = false
        }
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        navigationController?.hidesBarsOnSwipe = true
    }
    
}
