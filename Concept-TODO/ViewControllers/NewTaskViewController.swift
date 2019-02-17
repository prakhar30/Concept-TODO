//
//  NewTaskViewController.swift
//  Concept-TODO
//
//  Created by Prakhar Tripathi on 16/02/19.
//  Copyright © 2019 Prakhar Tripathi. All rights reserved.
//

import UIKit

class NewTaskViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var selectedDay: UISegmentedControl!
    static var textFieldText = ""
    
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
    
    @IBAction func closeButton(_ sender: Any) {
    }
}
