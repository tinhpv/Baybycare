//
//  RouteViewController.swift
//  Baby_Jaserick
//
//  Created by TinhPV on 1/24/19.
//  Copyright © 2019 TinhPV. All rights reserved.
//

import UIKit

class RouteViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var settingBarButton: UIBarButtonItem!
    @IBOutlet weak var addButton: UIButton!
    
    var customBar: UINavigationBar = UINavigationBar()
    
    var routeList: [Route] = []
    var shownRoute = [Bool](repeating: false, count: DBManager.sharedInstance.getAllRoutes().count)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initilizeTable()
        //animateTable()
    }
    
    override func viewDidLayoutSubviews() {
        addButton.makeItShadow()
    }
    
    func initilizeTable() {
        routeList = Array(DBManager.sharedInstance.getAllRoutes())
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.clear
        tableView.tableFooterView = UIView.init(frame: .zero)
    }
    
    @IBAction func addRouteTouched(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: Constant.Storyboard.detailRouteVC) as! NewRouteViewController
        vc.isNewRoute = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension RouteViewController: UITableViewDelegate, UITableViewDataSource {
    
    override func viewWillAppear(_ animated: Bool) {
        initilizeTable()
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            DBManager.sharedInstance.deleteRouteFromDb(object: routeList[indexPath.row])
            self.routeList.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constant.CellID.routeCell, for: indexPath) as! RouteTableViewCell
        cell.route = routeList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routeList.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: Constant.Storyboard.detailRouteVC) as! NewRouteViewController
        vc.mainRoute = routeList[indexPath.row]
        vc.isNewRoute = false
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, 500, 0, 0)
        cell.layer.transform = rotationTransform
        UIView.animate(withDuration: 0.5) {
            cell.layer.transform = CATransform3DIdentity
        }
    } // end
    
}
