//
//  ViewController.swift
//  Calculator
//
//  Created by Tikhon Belousko on 04/02/15.
//  Copyright (c) 2015 Tikhon Belousko. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var userIsInTheMiddleOfTypingANumber = false
    var brain = CalculatorBrain()
    
    var displayValue: Double? {
        get {
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        
        set {
            if let str = newValue {
                display.text = "\(str)"
            } else {
                display.text = " "
            }
        }
    }
    
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var history: UILabel!
    
    @IBAction func setVariable() {
        brain.variableValues["M"] = displayValue
        userIsInTheMiddleOfTypingANumber = false
        displayValue = brain.evaluate()
    }
    
    @IBAction func pushVariable() {
        brain.pushVariable("M")
        history.text = brain.description + " ="
    }
    
    @IBAction func clearDisplay() {
        displayValue = nil
        history.text = " "
        userIsInTheMiddleOfTypingANumber = false
        brain.clear()
    }
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        
        if digit != "."
            || display.text?.rangeOfString(".") == nil
            || !userIsInTheMiddleOfTypingANumber {
            
            if userIsInTheMiddleOfTypingANumber {
                display.text = display.text! + digit
            } else {
                display.text = digit
                userIsInTheMiddleOfTypingANumber = true
            }
        }
    }
    
    @IBAction func operate(sender: UIButton) {
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        if let operation = sender.currentTitle {
            displayValue = brain.performOperation(operation)
        }
        history.text = brain.description + " ="
    }
    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        displayValue = brain.pushOperand(displayValue!)
        history.text = brain.description + " ="
    }
}

