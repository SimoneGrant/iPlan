//
//  Entry.swift
//  iPlan
//
//  Created by Simone Grant on 2/9/18.
//  Copyright © 2018 Simone Grant. All rights reserved.
//

import Foundation
import RealmSwift

class Entry: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var date: Date?
    var parent = LinkingObjects(fromType: Section.self, property: "entries")
}
