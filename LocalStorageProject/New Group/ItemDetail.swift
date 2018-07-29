//
//  ItemDetail.swift
//  LocalStorageProject
//
//  Created by TEAM LVS on 7/29/18.
//  Copyright © 2018 Pankaj Kapoor. All rights reserved.
//

import Foundation

class ItemDetail {
    var itemName = ""
    var checked = false
    
    init(itemName : String , checked : Bool) {
        self.itemName = itemName
        self.checked = checked
    }
}
