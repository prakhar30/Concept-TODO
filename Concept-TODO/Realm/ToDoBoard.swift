//
//  ToDoBoard.swift
//  Concept-TODO
//
//  Created by Prakhar Tripathi on 16/02/19.
//  Copyright © 2019 Prakhar Tripathi. All rights reserved.
//

import Foundation
import RealmSwift

class ToDoBoard: Object {
    @objc dynamic var id = 0
    @objc dynamic var boardName = ""
    @objc dynamic var totalTasks = 0
    @objc dynamic var todoTasks = 0
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
