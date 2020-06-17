//
//  SetNameForRecordingViewController.swift
//  Record_Audio
//
//  Created by TinhPV on 1/25/19.
//  Copyright © 2019 TinhPV. All rights reserved.
//

import UIKit

protocol GetNameOfFileRecordingDelegate {
    func getNameOfFile(fileName: String)
}

class SetNameForRecordingViewController: UIViewController {

    @IBOutlet weak var fileNameTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var middleView: UIView!
    
    var getFileNameDelegate: GetNameOfFileRecordingDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorLabel.isHidden = true
        middleView.layer.cornerRadius = 10
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        if (fileNameTextField.text?.isEmpty)! {
            errorLabel.isHidden = false
            errorLabel.text = "File name is required!"
        } else {
            getFileNameDelegate?.getNameOfFile(fileName: fileNameTextField.text!)
            dismiss(animated: true, completion: nil)
        }
    
    }

}
