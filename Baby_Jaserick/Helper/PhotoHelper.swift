//
//  PhotoHelper.swift
//  Baby_Jaserick
//
//  Created by TinhPV on 1/27/19.
//  Copyright © 2019 TinhPV. All rights reserved.
//
import UIKit

class PhotoHelper: NSObject {
    
    var completionHandler : ((UIImage) -> Void)?
    
    func presentActionSheet(from viewController: UIViewController) {
        let alertController = UIAlertController(title: nil, message: "Where do you want to get your photo from?", preferredStyle: .actionSheet)
        
        
        // OPTION1 - CAMERA
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let capturePhotoAction = UIAlertAction(title: "Take Photo", style: .default) { (action) in
                self.presentImagePickerController(with: .camera, from: viewController)
            }
            
            alertController.addAction(capturePhotoAction)
        }
        
        
        // OPTION2 - LIBRARY
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let uploadPhotoAction = UIAlertAction(title: "Pick from library", style: .default) { (action) in
                self.presentImagePickerController(with: .photoLibrary, from: viewController)
            }
            
            alertController.addAction(uploadPhotoAction)
        }
        
        // OPTION3 - CANCEL
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        
        viewController.present(alertController, animated: true)
        
    }
    
    func presentImagePickerController(with sourceType: UIImagePickerController.SourceType, from viewController: UIViewController) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = sourceType
        imagePickerController.delegate = self
        
        viewController.present(imagePickerController, animated: true)
    }
    
    
}


extension PhotoHelper: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            completionHandler?(selectedImage)
        }

        picker.dismiss(animated: true)
    }
    
    
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

