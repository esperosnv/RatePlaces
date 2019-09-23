//
//  NewPlaceTableViewController.swift
//  Rate Places
//
//  Created by Nadzieja on 23/09/2019.
//  Copyright © 2019 Nadzieja Siwucha. All rights reserved.
//

import UIKit

class NewPlaceTableViewController: UITableViewController {
    
    
    @IBOutlet weak var photoOfPlace: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    
}

// MARK: Extension Text Fieldield Delegate

extension NewPlaceTableViewController: UITextFieldDelegate {
    
    // hide the keyboard by clicking on Done
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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



