//
//  DataManager.swift
//  Baby_Jaserick
//
//  Created by TinhPV on 1/27/19.
//  Copyright © 2019 TinhPV. All rights reserved.
//

import Foundation
import UIKit


enum FileType {
    case image
    case audio
    case icon
    case video
}

class DataManager {
    
    static let sharedInstance = DataManager()
    
    func clearDiskCache() {
        let fileManager = FileManager.default
        let myDocuments = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let diskCacheStorageBaseUrl = myDocuments.appendingPathComponent("diskCache")
        guard let filePaths = try? fileManager.contentsOfDirectory(at: diskCacheStorageBaseUrl, includingPropertiesForKeys: nil, options: []) else { return }
        for filePath in filePaths {
            try? fileManager.removeItem(at: filePath)
        }
    }
    
    func createDirectory(fileType: FileType) {
        var type = ""
        switch fileType {
        case .image:
            type = "child_images"
        case .icon:
            type = "icon"
        case .video:
            type = "video"
        default:
            type = "Sounds"
        }
        
        let fileManager = FileManager.default
        var tDocumentDirectory: URL?
        
        if fileType == .audio {
            tDocumentDirectory = fileManager.urls(for: .libraryDirectory, in: .userDomainMask).first
        } else {
            tDocumentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
        } // end if
        
        
        if tDocumentDirectory != nil {
            let filePath =  tDocumentDirectory!.appendingPathComponent("\(type)")
            if !fileManager.fileExists(atPath: filePath.path) {
                do {
                    try fileManager.createDirectory(atPath: filePath.path, withIntermediateDirectories: true, attributes: nil)
                } catch {
                    NSLog("Couldn't create document directory")
                }
            } // end not if
            NSLog("Document directory is \(filePath)")
        } // end if
        
       
    }
    
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func getLibraryDirectory() -> URL {
        let paths = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask)
        let libDirectory = paths[0]
        return libDirectory
    }
    
    func getFileUrl(fileType: FileType) -> URL {
        
        var type = ""
        switch fileType {
        case .image:
            type = "child_images"
            return getDocumentsDirectory().appendingPathComponent(type)
        case .icon:
            type = "icon"
            return getDocumentsDirectory().appendingPathComponent(type)
        case .video:
            type = "video"
            return getDocumentsDirectory().appendingPathComponent(type)
        default:
            return getLibraryDirectory().appendingPathComponent("Sounds")
        }
        
    }
    
    //==========
    func saveVideoFile(originalPath: URL) -> String? {
        createDirectory(fileType: .video)
        var fileURL = self.getFileUrl(fileType: .video)
        
        let vidName = UUID().uuidString
        fileURL.appendPathComponent("\(vidName).MOV")
        
        do {
            let vidData = try Data(contentsOf: originalPath)
            try vidData.write(to: fileURL)
            return vidName
        } catch {
            print(error)
            return nil
        }
    }
    
    func saveImageDocumentDirectory(imageName: String, image: UIImage, type: FileType) -> URL? {
        
        createDirectory(fileType: type)
        
        //let fileManager = FileManager.default
        
        var fileURL: URL?
        
        switch type {
        case .icon:
            fileURL = getFileUrl(fileType: type).appendingPathComponent("\(imageName).png")
            if let imageData = image.pngData() {
                do {
                    try imageData.write(to: fileURL!)
                    print("file saved")
                } catch {
                    print("error saving file:", error)
                }
                return fileURL
            } else {
                return nil
            }
            
            
        case .image:
            fileURL = getFileUrl(fileType: type).appendingPathComponent("\(imageName).jpg")
            if let imageData = image.jpegData(compressionQuality: 0.5) {
                do {
                    try imageData.write(to: fileURL!)
                    print("file saved")
                } catch {
                    print("error saving file:", error)
                }
                return fileURL
            } else {
                return nil
            }
            
        case .audio:
            fileURL = nil
        case .video:
            break
        }
        
        return nil
        
    }
 
    
    func getImageFromDocumentDirectory(imageName: String, type: FileType) -> UIImage? {
        let fileManager = FileManager.default
        // create the destination file url to save your image
        
        var fileURL: URL?
        
        switch type {
        case .icon:
            fileURL = getFileUrl(fileType: type).appendingPathComponent("\(imageName).png")
        case .image:
            fileURL = getFileUrl(fileType: type).appendingPathComponent("\(imageName).jpg")
        case .audio:
            fileURL = nil
        case .video:
            break
        }
        
        
        if fileManager.fileExists(atPath: fileURL!.path) {
            let image = UIImage(contentsOfFile: fileURL!.path)
            return image
        } else {
            return nil
        }
    }
    
    func deleteDirectory() {
        
        let fileManager = FileManager.default
        
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
        
        
        if fileManager.fileExists(atPath: paths ) {
            try! fileManager.removeItem(atPath: paths )
        } else {
            print("Something wrong")
        }
        
    }

}
