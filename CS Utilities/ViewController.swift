//
//  ViewController.swift
//  CS Utilities
//
//  Created by 王雪铮 on 2/28/19.
//  Copyright © 2019 王雪铮. All rights reserved.
//

import UIKit

let binaryPrefix = "0b"
let octalPrefix = "0"
let hexPrefix = "0x"


class ViewController: UIViewController, UITextFieldDelegate {

    // The text field for input
    @IBOutlet weak var inputTextField: UITextField!
    
    // All the output textFields
    @IBOutlet weak var binaryTextField: UITextField!
    @IBOutlet weak var octalTextField: UITextField!
    @IBOutlet weak var decimalTextField: UITextField!
    @IBOutlet weak var hexadecimalTextField: UITextField!
    
    // Detection mode selection
    @IBOutlet weak var detectionMode: UISegmentedControl!
    
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
    @IBAction func updateResults(_ sender: Any?) {
        
        // Calculation variables
        let input: String
        var workingSubstring: Substring
        let base: Int
        
        var decimalValue = 0
        
        // Cast to non-optional
        if inputTextField.text != nil && inputTextField.text != inputTextField.placeholder && inputTextField.text != "" {
            
            // Read in the input, parse base and inputNumber
            input = inputTextField.text!
            
            // Read the base information
            if detectionMode.selectedSegmentIndex != 0 {
                // Manual Selection Mode
                switch(detectionMode.selectedSegmentIndex){
                case 1:
                    base = 2
                    workingSubstring = input.suffix(input.count - binaryPrefix.count)
                    break
                case 2:
                    base = 8
                    workingSubstring = input.suffix(input.count - octalPrefix.count)
                    break
                case 3:
                    base = 10
                    workingSubstring = input.suffix(input.count)
                    break
                case 4:
                    base = 16
                    workingSubstring = input.suffix(input.count - hexPrefix.count)
                    break
                default:
                    exit(1)
                }
            } else {
                // Auto detect mode
                if input.hasPrefix(binaryPrefix) {
                    base = 2
                    workingSubstring = input.suffix(input.count - binaryPrefix.count)
                } else if input.hasPrefix(hexPrefix) {
                    base = 16
                    workingSubstring = input.suffix(input.count - hexPrefix.count)
                } else if input.hasPrefix(octalPrefix) {
                    base = 8
                    workingSubstring = input.suffix(input.count - octalPrefix.count)
                } else {
                    base = 10
                    workingSubstring = input.suffix(input.count)
                }
            }
            
            // Call helper method to parse the given string
            let result = convertFrom(number: workingSubstring, base: base)
            if result == nil {
                // Handle the error, creating an alert
                let alert = UIAlertController(title: "Error: incorrect format", message: "Please check your input, the format is as following:\nBinary # starts with \"0b\"\nOctal # starts with \"0\"\nDecimal # starts with a non-zero digit\nHexadecimal # starts with \"0x\"\n", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler:{ _ in
                    NSLog("The \"OK\" alert occured.")
                    }))
                self.present(alert, animated: true)
                
            } else {
                decimalValue = result!
                // Set Decimal
                decimalTextField.text = String(decimalValue)
            
                // Set Binary
                binaryTextField.text = binaryPrefix + convert(number: decimalValue, toBase: 2)!
            
                // Set Octal
                octalTextField.text = octalPrefix + convert(number: decimalValue, toBase: 8)!
            
                // Set Hexadecimal
                hexadecimalTextField.text = hexPrefix + convert(number: decimalValue, toBase: 16)!
            }
            
        } else {
            
            // Empty empty
            // Handle the error, creating an alert
            let alert = UIAlertController(title: "Empty!", message: "The input cannot be empty", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler:{ _ in
                NSLog("The \"OK\" alert occured.")
            }))
            self.present(alert, animated: true)
            
        }
        
        
    }
    
    
    
    
    
    // Function Name: convert()
    // Description: Taking an integer and a base as a input, find the integer's expansion in the given base.
    private func convert(number: Int, toBase base: Int) -> String? {
        
        let digitOfNumber = ["0","1","2","3","4","5","6","7","8","9","A","B","C","D","E","F",]
        
        
        // Error handling
        // When base is out of range
        if base > 16 || base < 2 {
            return nil
        }
        
        var result: String = ""
        var numberBuffer = number
        
        var i = 0 // Loop counter
        while numberBuffer != 0 {
            let thisDigit = numberBuffer % base
            
            // Add a space for every 4
            if i % 4 == 0 && i != 0 {
                result = " " + result
            }
            
            result = digitOfNumber[thisDigit] + result
            i += 1
            
            numberBuffer = numberBuffer / base
        }
        
        return result
    }
    
    
    
    
    
    // Function name: convertFrom()
    // Description: get the decimal integer that is represented by the string in given base
    private func convertFrom(number:Substring, base: Int) -> Int! {
        
        // Local variables
        var digitsFromRight: Int = 0
        var workingSubstring: Substring = number
        var result = 0
        
        /* Error Checking Error Conditions */
        // Return nil if the input is problematic
        if base < 2 {
            print("The base is less than 2!")
            return nil;
        }
        
        
        // Generate the decimal
        while ( workingSubstring.count != 0 ) {
            
            let workingChar = workingSubstring.last!        // Get the last character
            let charValue: Int
            
            if workingChar.isHexDigit {
                charValue = workingChar.hexDigitValue!
            } else {
                // Error: not a hexDigit
                return nil
            }
            
            // Check two error conditions: char not in [0, Z]
            if charValue < base {
                
                // Noting is wrong
                print("charValue: " + String(charValue))
                result += Int(Double(charValue) * pow(Double(base), Double(digitsFromRight)))
                
            } else {
                // Error: The value is greater than base
                return nil
            }
            
            // Remove the right most character
            workingSubstring = workingSubstring.prefix(workingSubstring.count - 1)
            // Increment the decimal d
            digitsFromRight += 1
            
        }
        
        return result
        
    }
    
}

