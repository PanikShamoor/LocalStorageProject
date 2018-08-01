//
//  CategoryData.swift
//  LocalStorageProject
//
//  Created by TEAM LVS on 7/30/18.
//  Copyright © 2018 Pankaj Kapoor. All rights reserved.
//

import Foundation
import RealmSwift

class CategoryData: Object {
    @objc dynamic var categoryName : String = ""
    let items = List<ItemData>()
}
