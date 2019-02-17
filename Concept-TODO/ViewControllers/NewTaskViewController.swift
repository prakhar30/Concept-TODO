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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.delegate  = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func closeButton(_ sender: Any) {
    }
}
