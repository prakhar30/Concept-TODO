//
//  RealmHelper.swift
//  Concept-TODO
//
//  Created by Prakhar Tripathi on 16/02/19.
//  Copyright © 2019 Prakhar Tripathi. All rights reserved.
//

import Foundation
import RealmSwift

class RealmHelper {
    
    class func getAllBoards() -> NSArray {
        var allBoards: Results<ToDoBoard> = try! Realm().objects(ToDoBoard.self)
        allBoards =  allBoards.sorted(byKeyPath: "id", ascending: true)
        return Array(allBoards) as NSArray
    }
    
    class func saveNewBoard(boardID: Int, boardName: String) {
        let board = ToDoBoard()
        board.id = boardID
        board.boardName = boardName
        board.totalTasks = 0
        board.todoTasks = 0
        
        let realm = try! Realm()
        try! realm.write {
            realm.add(board, update: true)
        }
    }
    
    class func getBoardTasks(boardID: Int) -> NSArray {
        var allBoards: Results<BoardTasks> = try! Realm().objects(BoardTasks.self).filter("boardID == \(boardID)")
        allBoards = allBoards.sorted(byKeyPath: "timeAdded", ascending: false)
        return Array(allBoards) as NSArray
    }
    
    class func saveTaskOnBoard(boardID: Int, name: String, isTaskForToday: Bool) {
        let task = BoardTasks()
        task.boardID = boardID
        task.taskName = name
        task.taskIsDone = false
        task.taskToBeDoneToday = isTaskForToday
        
        let realm = try! Realm()
        try! realm.write {
            realm.add(task, update: true)
        }
    }
    
}
