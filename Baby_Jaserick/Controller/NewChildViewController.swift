//
//  NewChildViewController.swift
//  Baby_Jaserick
//
//  Created by TinhPV on 1/27/19.
//  Copyright © 2019 TinhPV. All rights reserved.
//

import UIKit
import SearchTextField

class NewChildViewController: UIViewController {

    @IBOutlet weak var childImageView: UIImageView!
    @IBOutlet weak var childNameTextField: SearchTextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    
    let addButton = UIButton()
    let photoHelper = PhotoHelper()
    
    var child: Child? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI()
        self.hideKeyboardWhenTappedAround()
        
        photoHelper.completionHandler = { image in
            self.childImageView.image = image
            self.addButton.isHidden = true
        }
        autoCompleteChildNameSetup()
    }

    override func viewDidLayoutSubviews() {
        saveButton.layer.cornerRadius = 10
        saveButton.makeItShadow()
    }
    
    func autoCompleteChildNameSetup() {
        let results = DBManager.sharedInstance.getAllChildren()
        let nameList = Array(results.map {$0.name})
        var autoCompleteItem = [SearchTextFieldItem]()
        for i in nameList {
            autoCompleteItem.append(SearchTextFieldItem(title: i))
        }
        childNameTextField.filterItems(autoCompleteItem)
    }
    
    func initUI() {
        
        errorLabel.isHidden = true
        
        childImageView.layer.cornerRadius = childImageView.frame.height / 2
        childImageView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        childImageView.layer.borderWidth = 3.0
        
        addButton.setImage(UIImage(named: "plus"), for: .normal)
        addButton.addTarget(self, action: #selector(self.pickImage(_:)), for: .touchUpInside)
        addButton.isUserInteractionEnabled = true
        
        
        if self.child != nil { // old child
            
            if child?.imageURL != nil {
                self.childImageView.image = DataManager.sharedInstance.getImageFromDocumentDirectory(imageName: "\((child?.id)!)", type: .image)
            } else {
                childImageView.addSubview(addButton)
            }
            
            self.childNameTextField.text = child?.name
            
        } else { // new child
            
            childImageView.addSubview(addButton)
        }
        
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.pickImage(_:)))
        childImageView.isUserInteractionEnabled = true
        childImageView.addGestureRecognizer(tapGestureRecognizer)

    }
    
    @objc func pickImage(_ sender: UIButton) {
        photoHelper.presentActionSheet(from: self)
    }
    
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        if (childNameTextField.text?.isEmpty)! {
            errorLabel.text = "Please fill up child's name"
            errorLabel.isHidden = false
        } else if DBManager.sharedInstance.isDuplicatedChild(name: childNameTextField.text!) {
            errorLabel.text = "Child's name is already existed!"
            errorLabel.isHidden = false
        } else {
            if self.child == nil { // very new => create new
                let newChild = Child()
                newChild.name = childNameTextField.text!
                
                if childImageView.image != nil { // user has changed child image
                    // save image to document directory with name as childID
                    if let imageURL = DataManager.sharedInstance.saveImageDocumentDirectory(imageName: newChild.id, image: childImageView.image!, type: .image) {
                        newChild.imageURL = imageURL.absoluteString
                    }
                }
                // save child to realm
                DBManager.sharedInstance.addChild(object: newChild)
                
            } else { // old => just update
                if childImageView.image != nil { // user has changed child image
                    // save image to document directory with name as childID
                    if let imageURL = DataManager.sharedInstance.saveImageDocumentDirectory(imageName: (self.child?.id)!, image: childImageView.image!, type: .image) {
                        DBManager.sharedInstance.updateChild(childNameUpdate: childNameTextField.text!, imageURLUpdate: imageURL, with: (self.child?.id)!)
                    } // end if let
                } else {
                    DBManager.sharedInstance.updateChild(childNameUpdate: childNameTextField.text!, imageURLUpdate: nil, with: (self.child?.id)!)
                    
                }// end if not nil
            }
            
            // comeback
            self.navigationController?.popViewController(animated: true)
        } // end if
    } // end method
    
}
