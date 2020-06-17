//
//  Child.swift
//  Baby_Jaserick
//
//  Created by TinhPV on 1/26/19.
//  Copyright © 2019 TinhPV. All rights reserved.
//

import Foundation
import RealmSwift

class Child: Object {
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var name: String = ""
    @objc dynamic var imageURL: String? = nil
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
}
