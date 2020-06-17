//
//  VideoHelper.swift
//  Baby_Jaserick
//
//  Created by TinhPV on 2/21/19.
//  Copyright © 2019 TinhPV. All rights reserved.
//

import UIKit
import MobileCoreServices
import AVFoundation

class VideoHelper: NSObject {
    
    var completionHandler : ((String) -> Void)?
    var viewController: UIViewController?
    
    func presentActionSheet(from viewController: UIViewController) {
        let alertController = UIAlertController(title: nil, message: "Get a video from...", preferredStyle: .actionSheet)
        
        
        // OPTION1 - CAMERA
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let capturePhotoAction = UIAlertAction(title: "Using Camera", style: .default) { (action) in
                self.presentVideoPickerController(with: .camera, from: viewController)
            }
            
            alertController.addAction(capturePhotoAction)
        }
        
        
        // OPTION2 - LIBRARY
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let uploadPhotoAction = UIAlertAction(title: "Picking from Library", style: .default) { (action) in
                self.presentVideoPickerController(with: .savedPhotosAlbum, from: viewController)
            }
            
            alertController.addAction(uploadPhotoAction)
        }
        
        // OPTION3 - CANCEL
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        
        viewController.present(alertController, animated: true)
        
    } // end method
    
    
    
    func presentVideoPickerController(with sourceType: UIImagePickerController.SourceType, from viewController: UIViewController) {
        let mediaUI = UIImagePickerController()
        
        mediaUI.sourceType = sourceType
        mediaUI.delegate = self
        mediaUI.mediaTypes = [kUTTypeMovie as String]
        mediaUI.allowsEditing = true
        viewController.present(mediaUI, animated: true)
    }
    
}



extension VideoHelper: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if picker.sourceType == .camera {
            viewController?.dismiss(animated: true, completion: nil)
        }
        
        guard
            let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String, mediaType == (kUTTypeMovie as String),
            let videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL
            else { return }
        
        
        if picker.sourceType == .camera {
            guard UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(videoURL.path) else { return }
            UISaveVideoAtPathToSavedPhotosAlbum(videoURL.path, nil, nil, nil)
        }
        
        if let vidName = DataManager.sharedInstance.saveVideoFile(originalPath: videoURL) {
            completionHandler?(vidName)
        } else {
            completionHandler = nil
        }
        
        
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
}
