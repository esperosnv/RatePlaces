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
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var photoOfPlace: UIImageView!
    @IBOutlet weak var placeNameTextField: UITextField!
    @IBOutlet weak var placePositionTextField: UITextField!
    @IBOutlet weak var placeTypeTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveButton.isEnabled = false
        
        placeNameTextField.addTarget(self, action: #selector(textFileChanged), for: .editingChanged)
        
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
    
    
    
    // saveButton click
    func saveNewPlace() -> Place {
        
        newPlace = Place(name: placeNameTextField.text!,
                         position: placePositionTextField.text,
                         type: placeTypeTextField.text,
                         photo: photoOfPlace.image,
                         baseImage: nil)
        // будем принудительно вызывать  placeNameTextField.text!, поскольку мы точно уверены, что там есть текст, иначе бы кнопка не сработала бы.
        // photoName используется только для тестовых мест
        
        return newPlace!
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



