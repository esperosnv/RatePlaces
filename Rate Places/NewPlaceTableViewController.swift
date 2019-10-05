//
//  NewPlaceTableViewController.swift
//  Rate Places
//
//  Created by Nadzieja on 23/09/2019.
//  Copyright © 2019 Nadzieja Siwucha. All rights reserved.
//

import UIKit

class NewPlaceTableViewController: UITableViewController {
    
    var newPlace: Place?
    var editedPlace: Place?

    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var photoOfPlace: UIImageView!
    @IBOutlet weak var placeNameTextField: UITextField!
    @IBOutlet weak var placePositionTextField: UITextField!
    @IBOutlet weak var placeTypeTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveButton.isEnabled = false
        
        placeNameTextField.addTarget(self, action: #selector(textFileChanged), for: .editingChanged)
        
        setupEditedPlace()
        
        tableView.tableFooterView = UIView()
       
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            
            let cameraIcon = #imageLiteral(resourceName: "camera")
            let photoIcon = #imageLiteral(resourceName: "photo")
            
            let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            let cameraAlertAction = UIAlertAction(title: "Open Camera", style: .default) { _ in
                  self.chooseImagePicker(source: .camera)
            }
            cameraAlertAction.setValue(cameraIcon, forKey: "image")
            
            let photoAlertAction = UIAlertAction(title: "Choose Photo from Library", style: .default) { _ in
                  self.chooseImagePicker(source: .photoLibrary)
            }
            photoAlertAction.setValue(photoIcon, forKey: "image")
            
            let cancelAlertAction = UIAlertAction(title: "Cancel", style: .cancel)
            
            actionSheet.addAction(cameraAlertAction)
            actionSheet.addAction(photoAlertAction)
            actionSheet.addAction(cancelAlertAction)
            
            present(actionSheet, animated: true)
            
        } else {
            view.endEditing(true)
        }
    }
    
    
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    
    
    // MARK: - Save Button click
    
    func savePlace() {
        
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            
            newPlace = Place(context: context)

            newPlace?.name = placeNameTextField.text
            newPlace?.position = placePositionTextField.text
            newPlace?.type = placeTypeTextField.text
            newPlace?.photo = photoOfPlace.image?.pngData()
            newPlace?.baseImage = ""
            
            do {
                try context.save()
                print("Saving succeeded!")
            } catch let error as NSError {
                print("Saving failed! \(error), \(error.userInfo)")
            }
        }
    }
    
    // MARK: - Edit Place
    
    func setupEditedPlace() {
        
        if editedPlace != nil {
            
            guard let imageData = editedPlace?.photo, let imageOfEditedPlace = UIImage(data: imageData) else {return}
            
            photoOfPlace.image = imageOfEditedPlace
            placeNameTextField.text = editedPlace?.name
            placePositionTextField.text = editedPlace?.position
            placeTypeTextField.text = editedPlace?.type
            
            changeNavigationBarForEditedPlaces()
        }
    }
    
    func changeNavigationBarForEditedPlaces() {

        title = editedPlace?.name
        saveButton.isEnabled = true
        
    }
}

// MARK: Extension Text Fieldield Delegate

extension NewPlaceTableViewController: UITextFieldDelegate {
    
    // hide the keyboard by clicking on Done
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // addTarged func
    
    @objc func textFileChanged() {
        if placeNameTextField.text?.isEmpty == false  {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
    }
}


    // MARK: Choose and Add Photo using UIImagePickerContoller

extension NewPlaceTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func chooseImagePicker(source: UIImagePickerController.SourceType) {
        
        if UIImagePickerController.isSourceTypeAvailable(source) {
            
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = source
            imagePicker.allowsEditing = true
            present(imagePicker, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        photoOfPlace.image = info[.editedImage] as? UIImage
        dismiss(animated: true)
    }
    
}



