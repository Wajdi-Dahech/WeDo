//
//  Category.swift
//  WeDo
//
//  Created by Katsu on 8/11/20.
//  Copyright © 2020 Katsu. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
    
}
