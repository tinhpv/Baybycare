//
//  Child.swift
//  Baby_Jaserick
//
//  Created by TinhPV on 1/26/19.
//  Copyright © 2019 TinhPV. All rights reserved.
//

import Foundation
import RealmSwift

class DBManager {
    
    private var database: Realm
    static let sharedInstance = DBManager()
    
    private init() {
        database = try! Realm()
    }

    func getAllRoutes() -> Results<Route> {
        let results: Results<Route> = database.objects(Route.self)
        return results
    }
    
    
    func isDuplicatedRoute(name: String) -> Bool {
        let results = database.objects(Route.self).filter { (route) -> Bool in
            return route.routeName == name
        }
        if results.count == 0 {
            return false
        }
        return true
    }
    
    func isDuplicatedChild(name: String) -> Bool {
        let results = database.objects(Child.self).filter { (child) -> Bool in
            return child.name == name
        }
        if results.count == 0 {
            return false
        }
        return true
    }

    func getAllChildren() -> Results<Child> {
        let results: Results<Child> = database.objects(Child.self)
        return results
    }
    
    func addRoute(object: Route) {
        
        try! database.write {
            database.add(object, update: true)
            print("Added new Route")
        }
    }
    
    func addChild(object: Child) {
        try! database.write {
            database.add(object, update: true)
            print("Added new Child")
        }
    }
    
    func getRoute(primaryKey: String) -> Route? {
        return database.object(ofType: Route.self, forPrimaryKey: primaryKey) ?? nil
    }
    
    func updateRoute(with primaryKey: String, newRouteForUpdate: Route) {
        let route = database.object(ofType: Route.self, forPrimaryKey: primaryKey)
        if route != nil {
            try! database.write {
                database.add(newRouteForUpdate, update: true)
            }
        } // end if
    }
    
    func updateRouteList(listOfChildForUpdating: [Child], with primaryKey: String) {
        let route = database.object(ofType: Route.self, forPrimaryKey: primaryKey)
        if route != nil {
            let routeForUpdating = route
            routeForUpdating?.childList = List<Child>()
            routeForUpdating?.childList.append(objectsIn: listOfChildForUpdating)
            try! database.write {
                database.add(routeForUpdating!, update: true)
            }
        } // end if
    }
    
    func updateChild(childNameUpdate: String, imageURLUpdate: URL?, with primaryKey: String) {
        let child = database.object(ofType: Child.self, forPrimaryKey: primaryKey)
        if child != nil {
            let childForUpdating = Child()
            childForUpdating.id = primaryKey
            
            childForUpdating.name = childNameUpdate
            if let url = imageURLUpdate {
                childForUpdating.imageURL = url.absoluteString
            } else {
                childForUpdating.imageURL = nil
            }
            
            try! database.write {
                database.add(childForUpdating, update: true)
            }
        } // end if
    }
    
    func deleteRoute(deletedRoute: Route) {
        database.delete(deletedRoute)
    }
    
    func deleteAllDatabase()  {
        try! database.write {
            database.deleteAll()
        }
    }
    
    func deleteRouteFromDb(object: Route) {
        try! database.write {
            database.delete(object)
        }
    } // end delete
    
    func deleteChildFromDb(object: Child) {
        try! database.write {
            database.delete(object)
        }
    } // end delete
    
}

