//
//  ViewController.swift
//  Calc
//
//  Created by emathew4 on 9/12/17.
//  Copyright © 2017 emathew4. All rights reserved.
//

import UIKit

extension String {
    subscript (i: Int) -> Character{
        return self[index(startIndex, offsetBy: i)]
    }
    
    subscript (i:Int) -> String {
        return String(self[i] as Character)
    }
    subscript (r: Range<Int>) -> String {
        let start = index(startIndex, offsetBy: r.lowerBound)
        let end = index(startIndex, offsetBy: r.upperBound)
        return self[Range(start..<end)]
    }
}

extension String {
    var isOperator: Bool {
        get {
            return ("+ - / * ^ %" as NSString).contains(self)
        }
    }
    var isNumber: Bool {
        get {
            if let _ = Double(self) { return true }
            return false
        }
    }
    var precedence: Int {
        get {
            switch self {
            case "/":
                return 1
            case "*":
                return 1
            case "%":
                return 1
            case "+":
                return 2
            case "-":
                return 2
            case "^":
                return 0
            default:
                return -1
            }
        }
    }
}

class Stack {
    
    var selfvalue: [String] = []
    var peek: String {
        get {
            if selfvalue.count != 0 {
                return selfvalue[selfvalue.count-1]
            } else {
                return ""
            }
        }
    }
    var empty: Bool {
        get {
            return selfvalue.count == 0
        }
    }
    
    func push(value: String) {
        selfvalue.append(value)
    }
    
    func pop() -> String {
        var temp = String()
        if selfvalue.count != 0 {
            temp = selfvalue[selfvalue.count-1]
            selfvalue.remove(at: selfvalue.count-1)
        } else if selfvalue.count == 0 {
            temp = ""
        }
        return temp
    }
    
}

class MathParser {
    
    var outputQueue: [String] = []
    var stack: Stack = Stack()
 
    
    func parse(tokens: String) -> Double {
        if (tokens as NSString).contains("(") {
            var finalToks = ""
            var isTakingChars = false
            for i in tokens.characters {
                if i == ")" {
                    finalToks += "\(i)"
                    isTakingChars = false
                }
                if isTakingChars {
                    finalToks += "\(i)"
                }
                if i == "(" {
                    if finalToks != "" {
                        finalToks += "$"
                    }
                    finalToks += "\(i)"
                    isTakingChars = true
                }
            }
            for i in finalToks.components(separatedBy: "$") {
                var bracketOpen = "("
                var bracketClose = ")"
                var hand = MathParser()
                tokens = tokens.stringByReplacingOccurrencesOfString(i, withString: "\(hand.parse(i.stringByReplacingOccurrencesOfString(bracketClose, withString: String()).stringByReplacingOccurrencesOfString(bracketOpen, withString: String())))")
            }
        }
        var toksArr = tokens.components(separatedBy: " ")
        for token in toksArr {
            if token.isOperator {
                if stack.selfvalue.count != 0 {
                    for i in 0..<stack.selfvalue.count {
                        if stack.selfvalue.count != 0 {
                            if stack.peek.precedence <= token.precedence {
                                outputQueue.append(stack.pop())
                            }
                        }
                    }
                }
                stack.push(value: token)
            }
            if token.isNumber {
                outputQueue.append(token)
            }
        }
        while !stack.empty {
            outputQueue.append(stack.pop())
        }
        var newStack: Stack = Stack()
        for token in outputQueue {
            if token.isNumber {
                newStack.push(value: token)
            } else {
                var n1 = Double()
                var n2 = Double()
                if let _ = Double(newStack.peek) {
                    n1 = Double(newStack.pop())!
                    if let _ = Double(newStack.peek) {
                        n2 = Double(newStack.pop())!
                    }
                }
                
                var result = token == "+" ? n1 + n2 : token == "-" ? n2 - n1 : token == "*" ? n1 * n2 : token == "/" ? n2 / n1 :
                
                newStack.push(value: "\(result)")
            }
        }
        return Double(newStack.pop())!
        return 0.0
    }
    
}







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

