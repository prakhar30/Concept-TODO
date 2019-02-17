//
//  BoardDetailViewController.swift
//  Concept-TODO
//
//  Created by Prakhar Tripathi on 16/02/19.
//  Copyright © 2019 Prakhar Tripathi. All rights reserved.
//

import UIKit

class BoardDetailViewController: UIViewController {

    @IBOutlet weak var addButton: UIButton!
    var addTaskView = UIView()
    var addButtonFrame = CGRect()
    var addButtonPressed = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func setupViews() {
        addButton.layer.cornerRadius = 22.0
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
            self.addChild(addTaskVC)
            addTaskVC.view.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: 300.0)
            addTaskView.addSubview(addTaskVC.view)
            UIView.animate(withDuration: 0.5, animations: {
                self.addTaskView.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: 300.0)
                self.addTaskView.alpha = 1.0
            }) { (animationComplete) in
                if animationComplete {
                }
            }
        } else {
            self.view.endEditing(true)
            UIView.animate(withDuration: 0.5, animations: {
                self.addTaskView.alpha = 0.0
            }) { (animationComplete) in
                self.addTaskView.removeFromSuperview()
                self.addButtonPressed = false
                //SAVE textfieldvalue here and refresh the table
            }
        }
    }
}
