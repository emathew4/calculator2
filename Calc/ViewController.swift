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
    var nums: [Float] = []
    var opers: [String] = []
    var numParanLeft = 0
    
    @IBOutlet weak var answerDisplay: UILabel!
    @IBOutlet weak var equationDisplay: UILabel!
    
    @IBAction func tapNum(_ sender: UIButton) {
        isLastTapOperator = false
        if equationDisplay.text == "0" && sender.currentTitle == "0" {
            return
        }
        if isAlreadyTyping{
            equationDisplay.text = equationDisplay.text! + sender.currentTitle!
        } else {
            isAlreadyTyping = true
            equationDisplay.text = sender.currentTitle
        }
        
    }
    
    @IBAction func tapOperation(_ sender: UIButton) {
        if isLastTapOperator == false && equationDisplay.text?.characters.last != "("{
            equationDisplay.text = equationDisplay.text! + " " + sender.currentTitle! + " "
            isLastTapOperator = true
            isAlreadyTyping = true
        }
    }
    @IBAction func tapParanth(_ sender: UIButton) {
        let action = sender.currentTitle
        let lastChar = equationDisplay.text?.characters.last
        
        if action == "(" {
            isAlreadyTyping = true
            
            if lastChar != ")" && lastChar != "1" && lastChar != "2" && lastChar != "3" && lastChar != "4" && lastChar != "5" && lastChar != "6" && lastChar != "7" && lastChar != "8" && lastChar != "9"{
                if equationDisplay.text == "0" {
                    equationDisplay.text = "("
                    numParanLeft += 1
                }  else if lastChar != "0"{
                    numParanLeft += 1
                    equationDisplay.text = equationDisplay.text! + action!
                }
            }
        } else {
            if lastChar != "(" {
                if numParanLeft > 0 {
                    numParanLeft -= 1
                    equationDisplay.text = equationDisplay.text! + action!
                    isLastTapOperator = false
                }
            }
            
        }


    }
    
    @IBAction func tapClear(_ sender: UIButton) {
        equationDisplay.text = "0"
        isAlreadyTyping = false
        isLastTapOperator = false
        numParanLeft = 0
    }
    
    @IBAction func tapSwitchSign(_ sender: UIButton) {
        if equationDisplay.text == "0" || isLastTapOperator {
            isAlreadyTyping = true
            if equationDisplay.text == "0" {
                equationDisplay.text = "-"
            } else {
                let lastChar = equationDisplay.text?.characters.last
                if lastChar == "-" {
                    equationDisplay.text!.characters.removeLast()
                    equationDisplay.text = equationDisplay.text! + "+"
                }
                else {
                    equationDisplay.text = equationDisplay.text! + "-"
                }
            }
            
        }
    }
    
    @IBAction func tapEquals(_ sender: UIButton) {
    }
    
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

