//
//  ViewController.swift
//  Calc
//
//  Created by emathew4 on 9/12/17.
//  Copyright © 2017 emathew4. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    var isAlreadyTyping = false
    var isLastTapOperator = false
    var hasDecimal = false
    var nums: [Float] = []
    var opers: [String] = []
    var numParanLeft = 0
    
    @IBOutlet weak var answerDisplay: UILabel!
    @IBOutlet weak var equationDisplay: UILabel!
    
    func precedence(oper: String) -> Int {
        var prec = 0;
        if oper == "+" || oper == "-" {
            prec = 1
        } else if oper == "x" || oper == "÷" {
            prec = 2
        }
        return prec
    }
    
    func parseEquation(equat: String) -> String {
        var output = ""
        output = output + ""
        return output
    }

    
    @IBAction func tapNum(_ sender: UIButton) {
        isLastTapOperator = false
        if equationDisplay.text == "0" && sender.currentTitle == "0" {
            return
        }
        if hasDecimal && sender.currentTitle == "." {
            return
        }
        let lastChar = equationDisplay.text?.characters.last
        if isAlreadyTyping {
            if lastChar != ")" {
                if sender.currentTitle == "." {
                    hasDecimal = true
                    if lastChar == "(" || lastChar == " "{
                        equationDisplay.text = equationDisplay.text! + "0"
                    }
                }
                equationDisplay.text = equationDisplay.text! + sender.currentTitle!
            }
        } else {
            isAlreadyTyping = true
            if sender.currentTitle == "." {
                equationDisplay.text = "0."
                hasDecimal = true
            } else {
                equationDisplay.text = sender.currentTitle
            }
        }
        
    }
    
    @IBAction func tapOperation(_ sender: UIButton) {
        if isLastTapOperator == false && equationDisplay.text?.characters.last != "(" && equationDisplay.text?.characters.last != "." {
            equationDisplay.text = equationDisplay.text! + " " + sender.currentTitle! + " "
            isLastTapOperator = true
            isAlreadyTyping = true
            hasDecimal = false
        }
    }
    @IBAction func tapParanth(_ sender: UIButton) {
        let action = sender.currentTitle
        let lastChar = equationDisplay.text?.characters.last
        if lastChar == "." {
            return
        }
        
        if action == "(" {
            isAlreadyTyping = true
            hasDecimal = false
            if lastChar != ")" && lastChar != "1" && lastChar != "2" && lastChar != "3" && lastChar != "4" && lastChar != "5" && lastChar != "6" && lastChar != "7" && lastChar != "8" && lastChar != "9"{
                if equationDisplay.text == "0" {
                    equationDisplay.text = " ( "
                    numParanLeft += 1
                }  else if lastChar != "0"{
                    numParanLeft += 1
                    equationDisplay.text = equationDisplay.text! + " " + action! + " "
                }
            }
        } else {
            if lastChar != "(" && lastChar != " " {
                if numParanLeft > 0 {
                    numParanLeft -= 1
                    equationDisplay.text = equationDisplay.text! + " " + action! + " "
                    isLastTapOperator = false
                    hasDecimal = false
                }
            }
            
        }


    }
    
    @IBAction func tapClear(_ sender: UIButton) {
        equationDisplay.text = "0"
        isAlreadyTyping = false
        isLastTapOperator = false
        hasDecimal = false
        numParanLeft = 0
    }
    
    @IBAction func tapSwitchSign(_ sender: UIButton) {
        let lastChar = equationDisplay.text?.characters.last
        if equationDisplay.text == "0" || isLastTapOperator || lastChar == "-" || lastChar == "(" {
            isAlreadyTyping = true
            if equationDisplay.text == "0" {
                equationDisplay.text = "-"
            } else {
                if lastChar == "-" {
                    if equationDisplay.text == "-" {
                        equationDisplay.text = "0"
                    } else {
                        equationDisplay.text!.characters.removeLast()
                        equationDisplay.text = equationDisplay.text! + "+"
                    }

                }
                else if lastChar == "+"{
                    equationDisplay.text!.characters.removeLast()
                    equationDisplay.text = equationDisplay.text! + "-"
                } else {
                    equationDisplay.text = equationDisplay.text! + "-"
                }
            }
            
        }
    }
    
    @IBAction func tapEquals(_ sender: UIButton) {
        if numParanLeft != 0 {
            print("Please close all brackets")
        }
        let output = parseEquation(equat: equationDisplay.text!)
        answerDisplay.text = output
        
        nums = []
        opers = []
    }
    
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

