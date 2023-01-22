//
//  Category.swift
//  Todoey
//
//  Created by Juliano Santos on 11/1/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic  var colour: String = ""
    let items = List<Item>()
}
