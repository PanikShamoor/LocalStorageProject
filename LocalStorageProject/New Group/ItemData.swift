//
//  ItemData.swift
//  LocalStorageProject
//
//  Created by TEAM LVS on 7/30/18.
//  Copyright © 2018 Pankaj Kapoor. All rights reserved.
//

import Foundation
import RealmSwift

class ItemData: Object {
    @objc dynamic var itemName : String = ""
    @objc dynamic var checked : Bool = false
    @objc dynamic var dateCreated : Date?
    var parentCategory = LinkingObjects(fromType: CategoryData.self, property: "items")
}
