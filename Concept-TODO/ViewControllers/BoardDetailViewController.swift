//
//  BoardDetailViewController.swift
//  Concept-TODO
//
//  Created by Prakhar Tripathi on 16/02/19.
//  Copyright © 2019 Prakhar Tripathi. All rights reserved.
//

import UIKit
extension BoardDetailViewController: newTaskCloseButtonProtocol {
    func closeNewTaskView() {
        self.removeAddTaskViewFromSuperView()
    }
}

class BoardDetailViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    var addTaskView = UIView()
    var addButtonFrame = CGRect()
    var addButtonPressed = false
    var selectedBoardID: Int?
    var boardData: NSArray?
    var tasksForToday = [BoardTasks]()
    var tasksForTomorrow = [BoardTasks]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let id = selectedBoardID {
            boardData = RealmHelper.getBoardTasks(boardID: id)
            processData()
            tableView.reloadData()
        }
        setupViews()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func setupViews() {
        addButton.layer.cornerRadius = 22.0
        tableView.tableFooterView = UIView()
    }
    
    func processData() {
        tasksForToday.removeAll()
        tasksForTomorrow.removeAll()
        
        if let data = boardData {
            for datum in data {
                let task = datum as! BoardTasks
                if task.taskToBeDoneToday {
                    tasksForToday.append(task)
                } else {
                    tasksForTomorrow.append(task)
                }
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addButtonFrame = addButton.frame
    }
    
    @objc func keyboardDidShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            self.changeAddButtonSizeToSquareAndUpdatePosition(keyboardHeight: keyboardHeight)
        }
    }
    
    @objc func keyboardDidHide(_ notification: Notification) {
        changeAddButtonSizeToCircleAndUpdatePosition()
    }
    
    func changeAddButtonSizeToSquareAndUpdatePosition(keyboardHeight: CGFloat) {
        UIView.animate(withDuration: 0.1, animations: {
            self.addButton.frame = CGRect(x: 0.0, y: self.view.frame.height - keyboardHeight - 40, width: self.view.frame.width, height: 40)
            self.addButton.layer.cornerRadius = 0.0
        }) { (_) in
        }
    }
    
    func changeAddButtonSizeToCircleAndUpdatePosition() {
        UIView.animate(withDuration: 0.1, animations: {
            self.addButton.frame = self.addButtonFrame
            self.addButton.layer.cornerRadius = 22.0
        }) { (_) in
        }
    }
    
    @IBAction func addButtonAction(_ sender: Any) {
        if !addButtonPressed {
            addButtonPressed = true
            addTaskView = UIView(frame: CGRect(x: 0.0, y: 300.0, width: self.view.frame.width, height: 300.0))
            addTaskView.alpha = 0.0
            self.view.addSubview(addTaskView)
            
            let addTaskVC = self.storyboard?.instantiateViewController(withIdentifier: "NewTaskViewController_ID") as! NewTaskViewController
            addTaskVC.delegate = self
            self.addChild(addTaskVC)
            addTaskVC.view.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: 300.0)
            addTaskView.addSubview(addTaskVC.view)
            UIView.animate(withDuration: 0.5, animations: {
                self.addTaskView.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: 300.0)
                self.addTaskView.alpha = 1.0
                self.tableView.alpha = 0.0
            }) { (animationComplete) in
                if animationComplete {
                }
            }
        } else {
            self.view.endEditing(true)
            UIView.animate(withDuration: 0.5, animations: {
                self.addTaskView.alpha = 0.0
                self.tableView.alpha = 1.0
            }) { (animationComplete) in
                self.addTaskView.removeFromSuperview()
                self.addButtonPressed = false
                self.saveTaskToDB()
                self.addRowToTable()
            }
        }
    }
    
    func saveTaskToDB() {
        if NewTaskViewController.textFieldText != "" {
            if NewTaskViewController.indexSelected == 0 {
                RealmHelper.saveTaskOnBoard(boardID: self.selectedBoardID!, name: NewTaskViewController.textFieldText, isTaskForToday: true)
            } else {
                RealmHelper.saveTaskOnBoard(boardID: self.selectedBoardID!, name: NewTaskViewController.textFieldText, isTaskForToday: false)
            }
        }
    }
    
    func addRowToTable() {
        if NewTaskViewController.textFieldText != "" {
            let task = BoardTasks()
            task.taskIsDone = false
            task.taskName = NewTaskViewController.textFieldText
            task.boardID = selectedBoardID!
            if NewTaskViewController.indexSelected == 0 {
                task.taskToBeDoneToday = true
                tasksForToday.insert(task, at: 0)
            } else {
                task.taskToBeDoneToday = false
                tasksForTomorrow.insert(task, at: 0)
            }
            NewTaskViewController.indexSelected = 0
            NewTaskViewController.textFieldText = ""
            self.tableView.reloadData()
        }
    }
    
    func removeAddTaskViewFromSuperView() {
        self.view.endEditing(true)
        self.addButtonPressed = false
        UIView.animate(withDuration: 0.5, animations: {
            self.addTaskView.alpha = 0.0
            self.tableView.alpha = 1.0
        }) { (animationComplete) in
            self.addTaskView.removeFromSuperview()
        }
    }
    
}

extension BoardDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Today"
        } else {
            return "Tomorrow"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return tasksForToday.count
        } else {
            return tasksForTomorrow.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: BoardDetailTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! BoardDetailTableViewCell
        
        if indexPath.section == 0 {
            cell.taskLabel.text = tasksForToday[indexPath.row].taskName
        } else {
            cell.taskLabel.text = tasksForTomorrow[indexPath.row].taskName
        }
        
        return cell
    }
}
