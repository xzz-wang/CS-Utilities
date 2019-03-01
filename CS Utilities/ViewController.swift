//
//  ViewController.swift
//  CS Utilities
//
//  Created by 王雪铮 on 2/28/19.
//  Copyright © 2019 王雪铮. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    // The text field for input
    @IBOutlet weak var inputTextField: UITextField!
    
    // All the output textFields
    @IBOutlet weak var binaryTextField: UITextField!
    @IBOutlet weak var octalTextField: UITextField!
    @IBOutlet weak var decimalTextField: UITextField!
    @IBOutlet weak var hexadecimalTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Set delegation
        inputTextField.delegate = self
    }

    // MARK: The UITextFieldDelegate methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        // Hide the keyboard
        textField.resignFirstResponder()
        
        return true;
    }
    
    // Called when textFieldDidEndEditing
    @IBAction func updateResults(_ sender: UITextField) {
        
        var input: String
        
        // Cast to non-optional
        if inputTextField.text != nil {
            input = inputTextField.text!
            binaryTextField.text = input
        }
        
        
    }
    
}

