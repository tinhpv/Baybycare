//
//  ShowErrorViewController.swift
//  Baby_Jaserick
//
//  Created by TinhPV on 1/28/19.
//  Copyright © 2019 TinhPV. All rights reserved.
//

import UIKit

class ShowErrorViewController: UIViewController {

    @IBOutlet weak var errorLabel: UILabel!
    
    var error: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorLabel.text = error!
    }
    
    @IBAction func dismissButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

}
