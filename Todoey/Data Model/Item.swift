//
//  Item.swift
//  Todoey
//
//  Created by Juliano Santos on 11/1/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date? = nil
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
