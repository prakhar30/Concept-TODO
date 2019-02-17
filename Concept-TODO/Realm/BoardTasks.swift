//
//  BoardTasks.swift
//  Concept-TODO
//
//  Created by Prakhar Tripathi on 17/02/19.
//  Copyright © 2019 Prakhar Tripathi. All rights reserved.
//

import Foundation
import RealmSwift

class BoardTasks: Object {
    @objc dynamic var id = NSUUID().uuidString
    @objc dynamic var boardID = 0
    @objc dynamic var taskName = ""
    @objc dynamic var taskIsDone = false
    @objc dynamic var taskToBeDoneToday = false
    @objc dynamic var timeAdded = Date()
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
