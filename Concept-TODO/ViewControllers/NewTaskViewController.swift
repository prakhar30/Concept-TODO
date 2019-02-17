//
//  NewTaskViewController.swift
//  Concept-TODO
//
//  Created by Prakhar Tripathi on 16/02/19.
//  Copyright © 2019 Prakhar Tripathi. All rights reserved.
//

import UIKit
protocol newTaskCloseButtonProtocol: class {
    func closeNewTaskView()
}

class NewTaskViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var selectedDay: UISegmentedControl!
    static var textFieldText = ""
    static var indexSelected = 0
    weak var delegate: newTaskCloseButtonProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.delegate  = self
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        NewTaskViewController.textFieldText = textField.text!
    }
    
    @IBAction func dayIndexChanged(_ sender: Any) {
        NewTaskViewController.indexSelected = selectedDay.selectedSegmentIndex
    }
    
    @IBAction func closeButton(_ sender: Any) {
        delegate?.closeNewTaskView()
    }
}
