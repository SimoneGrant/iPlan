//
//  Category.swift
//  iPlan
//
//  Created by Simone Grant on 2/9/18.
//  Copyright © 2018 Simone Grant. All rights reserved.
//

import Foundation
import RealmSwift

class Section: Object {
    @objc dynamic var categoryName: String = ""
    @objc dynamic var color: String = ""
    let entries = List<Entry>()
}
