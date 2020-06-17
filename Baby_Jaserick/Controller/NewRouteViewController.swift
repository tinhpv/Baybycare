//
//  NewRouteViewController.swift
//  Baby_Jaserick
//
//  Created by TinhPV on 1/24/19.
//  Copyright © 2019 TinhPV. All rights reserved.
//

import UIKit
import SearchTextField

class NewRouteViewController: UIViewController {

    // - MARK: iboutlet
    @IBOutlet weak var routeNameTextField: SearchTextField!
    @IBOutlet weak var routeIconImageView: UIImageView!
    @IBOutlet weak var iconPickButton: UIButton!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var playContainerView: UIView!
    @IBOutlet weak var childTableView: UITableView!
    @IBOutlet weak var bottomContainer: UIView!
    
    
    // - MARK: for manual picker
    @IBOutlet weak var manualPickerContainer: UIView!
    @IBOutlet weak var manualHourPicker: UIPickerView!
    @IBOutlet weak var manualMinutePicker: UIPickerView!
    @IBOutlet weak var quicktimePicker: UIPickerView!

    // - MARK: data for picker
    var dataForQuickTimePicker: [Int] = [Int]()
    var dataHourForManualTimePicker: [Int] = [Int]()
    var dataMinuteForManualTimePicker: [Int] = [Int]()
    
    // - MARK: timer
    var timer = Timer()
    var isTimerRunning = false
    var counter: TimeInterval = 0
    var trackCounter: TimeInterval = 0
    var endDate: Date?
    
    // - MARK: data for child table
    var childList: [Child] = []
    var selectedChildList: [Child] = []
    
    // - MARK: local variables
    var mainRoute: Route? = nil
    var isQuickTimeSelected = true // quicktime is default picker
    var minuteOfQuickTimePicker: Int = 0
    var minuteOfManualPicker: Int = 0
    var hour: Int = 0
    var isNewRoute: Bool? = false
    
    var selectedIconImage: UIImage? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareData()
        
        self.setDelegateAndDataSource(for: self.quicktimePicker)
        self.setDelegateAndDataSource(for: self.manualHourPicker)
        self.setDelegateAndDataSource(for: self.manualMinutePicker)
        
        self.initUI()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.prepareData()
        childTableView.reloadData()
        initUI()
    }
    
    
    // - MARK: custom function
    private func prepareData() {
        // get all names
        autoCompleteRouteNameSetup()
        
        if mainRoute != nil {
            selectedChildList = Array((mainRoute?.childList)!)
        }
        
        childList = Array(DBManager.sharedInstance.getAllChildren())
        dataForQuickTimePicker = [5, 10, 15, 20, 25, 45, 95]
        dataHourForManualTimePicker = Array(0...10)
        dataMinuteForManualTimePicker = Array(1...59)
    }
    
    func autoCompleteRouteNameSetup() {
        let results = DBManager.sharedInstance.getAllRoutes()
        let nameList = Array(results.map {$0.routeName})
        var autoCompleteItem = [SearchTextFieldItem]()
        for i in nameList {
            autoCompleteItem.append(SearchTextFieldItem(title: i))
        }
        routeNameTextField.filterItems(autoCompleteItem)
    }
    
    private func setDelegateAndDataSource(for picker: UIPickerView) {
        picker.delegate = self
        picker.dataSource = self
    }
    
    private func initUI() {
        
        manualPickerContainer.isHidden = true
        playContainerView.layer.cornerRadius = 10
        iconPickButton.frame.size = CGSize(width: 20, height: 20)
        iconPickButton.setImage(UIImage(named: "plus"), for: .normal)
        
        if mainRoute == nil {
            self.title = "New Route"
            self.isQuickTimeSelected = true
            self.minuteOfQuickTimePicker = 5
            routeIconImageView.isHidden = true
            quicktimePicker.isHidden = false
            self.isNewRoute = true
        } else {
            self.title = mainRoute?.routeName
            self.routeNameTextField.text = mainRoute?.routeName
            
            // icon
            if mainRoute?.icon != nil {
                iconPickButton.isHidden = true
                routeIconImageView.isHidden = false

                self.routeIconImageView.image = DataManager.sharedInstance.getImageFromDocumentDirectory(imageName: (mainRoute?.routeID)!, type: .icon)
                
                
                let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.iconPickerTapped(_:)))
                routeIconImageView.isUserInteractionEnabled = true
                routeIconImageView.addGestureRecognizer(tapGestureRecognizer)
            }
            
            // active or note
            if (mainRoute?.isActive)! {
                segmentedControl.isEnabled = false
                self.manualHourPicker.isUserInteractionEnabled = false
                self.manualMinutePicker.isUserInteractionEnabled = false
                self.quicktimePicker.isUserInteractionEnabled = false
                
            } else {
                segmentedControl.isEnabled = true
                self.manualHourPicker.isUserInteractionEnabled = true
                self.manualMinutePicker.isUserInteractionEnabled = true
                self.quicktimePicker.isUserInteractionEnabled = true
            }
            
            self.setStatusForQuicker()
        }
        
//        childContainer.layer.cornerRadius = 10
        bottomContainer.roundCorners(corners: [.topLeft, .topRight], radius: 40)
        childTableView.tableFooterView = UIView.init(frame: .zero)
        let barButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(self.saveRoute))
        
        self.segmentedControl.setTitleTextAttributes([NSAttributedString.Key.font : UIFont(name: "Futura", size: 16)!], for: .normal)
        self.navigationItem.rightBarButtonItem = barButton
        
    }
    
    
    func setStatusForQuicker() {
        if mainRoute?.pickerWay != nil {
            if (mainRoute?.pickerWay?.elementsEqual("quicktime"))! {
                
                self.isQuickTimeSelected = true
                self.minuteOfQuickTimePicker = Int((mainRoute?.minute)!)!
                
                let index = dataForQuickTimePicker.firstIndex(of: self.minuteOfQuickTimePicker)
                self.quicktimePicker.selectRow(index!, inComponent: 0, animated: false)
                
            } else {
                
                self.isQuickTimeSelected = false
                self.minuteOfManualPicker = Int((mainRoute?.minute)!)!
                self.hour = Int((mainRoute?.hour)!)!
                
                self.segmentedControl.selectedSegmentIndex = 1
                self.quicktimePicker.isHidden = true
                self.manualPickerContainer.isHidden = false
                
                var index = dataHourForManualTimePicker.firstIndex(of: self.hour)
                manualHourPicker.selectRow(index!, inComponent: 0, animated: false)
                index = dataMinuteForManualTimePicker.firstIndex(of: self.minuteOfManualPicker)
                manualMinutePicker.selectRow(index!, inComponent: 0, animated: false)
            }
            
        }
        
    }
    
    
    func createNewRoute() {
        
        let newRoute = Route()
        
        if mainRoute != nil {
            newRoute.routeID = (mainRoute?.routeID)!
            newRoute.isActive = (mainRoute?.isActive)!
        }
        
        newRoute.routeName = self.routeNameTextField.text!
        
        if self.isQuickTimeSelected {
            newRoute.pickerWay = "quicktime"
            newRoute.minute = "\(self.minuteOfQuickTimePicker)"
        } else {
            newRoute.pickerWay = "manual"
            newRoute.hour = "\(self.hour)"
            newRoute.minute = "\(self.minuteOfManualPicker)"
        }
        
        newRoute.childList.append(objectsIn: self.selectedChildList)
        
        if let icon = self.selectedIconImage {
            if let url = DataManager.sharedInstance.saveImageDocumentDirectory(imageName: newRoute.routeID, image: icon, type: .icon) {
                newRoute.icon = url.absoluteString
            } // end if url
            
        } // end if
        
        if mainRoute != nil {
            DBManager.sharedInstance.updateRoute(with: (mainRoute?.routeID)!, newRouteForUpdate: newRoute)
        } else {
            DBManager.sharedInstance.addRoute(object: newRoute)
            mainRoute = newRoute
        }
        
    }
    
    
    func showAlert(message: String, status: String) {
        let alert = UIAlertController(title: status, message: message, preferredStyle: .alert)
        let cancelButton = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(cancelButton)
        self.present(alert, animated: true)
    }
    
   
    // - MARK: IBAction of component
    
    @objc func saveRoute() {
        // Check name whether empty or not
        if (self.routeNameTextField.text?.isEmpty)! {
            self.showAlert(message: "Fill up route's name!", status: "Error")
            
        // Check selected child list whether empty or not
        } else if DBManager.sharedInstance.isDuplicatedRoute(name: routeNameTextField.text!) {
            self.showAlert(message: "This name is already existed!", status: "Error")
        } else if self.selectedChildList.count == 0 {
            self.showAlert(message: "Choose at lease one child for this route", status: "Error")
            
        } else {
            // check time whether selected or not
            if self.isQuickTimeSelected, self.minuteOfQuickTimePicker == 0 { // ==> quicktime picker
                self.showAlert(message: "Please set time for your child(ren)", status: "Error")
            } else if !self.isQuickTimeSelected, self.minuteOfManualPicker == 0, self.hour == 0 { // ==> manual picker
                self.showAlert(message: "Please set time for your child(ren)", status: "Error")
            } else {
                // now everything is ok, let's save your data to realm
                self.createNewRoute()
                self.initUI()
                self.showAlert(message: "", status: "SAVED")
            }
        } // end if
    }
    
    func showError(error: String) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: Constant.Storyboard.showErrorVC) as! ShowErrorViewController
        vc.error = error
        present(vc, animated: true)
    }
    

    @IBAction func iconPickerTapped(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: Constant.Storyboard.iconCollectionVC) as! IconConllectionViewController
        vc.iconPickingDelegate = self
        present(vc, animated: true)
    }
    
    @IBAction func tabSelected(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex {
        case 1:
            quicktimePicker.isHidden = true
            manualPickerContainer.isHidden = false
            isQuickTimeSelected = false
            self.minuteOfManualPicker = self.dataMinuteForManualTimePicker[0]
            self.hour = self.dataHourForManualTimePicker[0]
        default:
            quicktimePicker.isHidden = false
            manualPickerContainer.isHidden = true
            isQuickTimeSelected = true
            self.minuteOfQuickTimePicker = self.dataForQuickTimePicker[0]
        }
    }
    
    @IBAction func addChildButtonTapped(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: Constant.Storyboard.newChildVC) as! NewChildViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func playButtonTapped(_ sender: Any) {
        if mainRoute != nil {
            if selectedChildList.isEmpty {
                self.showAlert(message: "Choose at least one child!", status: "ERROR")
            } else {
                createNewRoute()
                let currentActiveRouteSave = UserDefaults.standard
                currentActiveRouteSave.setValue(mainRoute!.routeID, forKey: Constant.KeyProgram.activeRouteID)
                
                let playVC = self.storyboard?.instantiateViewController(withIdentifier: Constant.Storyboard.playVC) as! PlayViewController
                playVC.currentRoute = self.mainRoute
                present(playVC, animated: true)
            }
        } else {
            self.showAlert(message: "Save this route before playing", status: "ERROR")
        } // end if
    }
}

extension NewRouteViewController: IconPickingDelegate {
    func pickIcon(selectedIcon: UIImage) {
        self.routeIconImageView.isHidden = false
        self.iconPickButton.isHidden = true
        self.routeIconImageView.image = selectedIcon
        self.selectedIconImage = selectedIcon
    }
}

extension NewRouteViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView == quicktimePicker {
            return 1
        } else if pickerView == manualHourPicker {
            return 1
        } else {
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == manualHourPicker {
            return dataHourForManualTimePicker.count
        } else if pickerView == manualHourPicker {
            return dataMinuteForManualTimePicker.count
        } else {
            return dataForQuickTimePicker.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        if pickerView == manualMinutePicker {
            let string = "\(dataMinuteForManualTimePicker[row])"
            return NSAttributedString(string: string, attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)])
        } else if pickerView == manualHourPicker {
            let string = "\(dataHourForManualTimePicker[row])"
            return NSAttributedString(string: string, attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)])
        } else {
            let string = "\(dataForQuickTimePicker[row]) min"
            return NSAttributedString(string: string, attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)])
        } // end if
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == quicktimePicker {
            self.isQuickTimeSelected = true
            self.minuteOfQuickTimePicker = dataForQuickTimePicker[row]
        } else if pickerView == manualHourPicker {
            self.hour = dataHourForManualTimePicker[row]
            self.isQuickTimeSelected = false
        } else if pickerView == manualMinutePicker {
            self.minuteOfManualPicker = dataMinuteForManualTimePicker[row]
            self.isQuickTimeSelected = false
        }
    }
    
}

extension NewRouteViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: Constant.Storyboard.newChildVC) as! NewChildViewController
        vc.child = childList[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 69.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return childList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = childTableView.dequeueReusableCell(withIdentifier: Constant.CellID.childCell, for: indexPath) as! ChildTableViewCell
        
        cell.child = childList[indexPath.row]
        cell.viewControllerOfCell = self
        
        if selectedChildList.contains(childList[indexPath.row]) {
            cell.isSelectedChild = true
        } else {
            cell.isSelectedChild = false
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.alpha = 0
        UIView.animate(withDuration: 0.6) {
            cell.alpha = 1
        }
    }
}
