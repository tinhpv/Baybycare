//
//  Work.swift
//  Baby_Jaserick
//
//  Created by TinhPV on 1/26/19.
//  Copyright © 2019 TinhPV. All rights reserved.
//

import Foundation
import RealmSwift

class Route: Object {
    @objc dynamic var routeID: String = UUID().uuidString
    @objc dynamic var routeName: String = ""
    @objc dynamic var icon: String? = nil
    @objc dynamic var hour: String? = nil
    @objc dynamic var minute: String? = nil
    @objc dynamic var pickerWay: String? = nil
    @objc dynamic var isActive: Bool = false
    
    var childList = List<Child>()
    
    override class func primaryKey() -> String? {
        return "routeID"
    }
}
