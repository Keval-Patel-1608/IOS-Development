//
//  ViewController.swift
//  CalculatorUI
//
//  Created by user244717 on 5/15/24.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func buttonClear(_ sender: UIButton) {
        print("AC")
    }
    @IBAction func buttonDot(_ sender: UIButton) {
        print(".")
    }
    @IBAction func buttonEqual(_ sender: UIButton) {
        print("=")
    }
    @IBAction func buttonAdd(_ sender: UIButton) {
        print("+")
    }
    @IBAction func buttonSubstract(_ sender: UIButton) {
        print("-")
    }
    @IBAction func buttonMultiply(_ sender: UIButton) {
        print("x")
    }
    @IBAction func buttonDivide(_ sender: UIButton) {
        print("/")
    }
    @IBAction func buttonSquare(_ sender: UIButton) {
        print("^2")
    }
    @IBAction func buttonInvert(_ sender: UIButton) {
        print("+/-")
    }
    
    @IBAction func buttonZero(_ sender: UIButton) {
        print("0")
    }
    @IBAction func buttonOne(_ sender: UIButton) {
        print("1")
    }
    @IBAction func buttonTwo(_ sender: UIButton) {
        print("2")
    }
    @IBAction func buttonThree(_ sender: UIButton) {
        print("3")
    }
    @IBAction func buttonFour(_ sender: UIButton) {
        print("4")
    }
    @IBAction func buttonFive(_ sender: UIButton) {
        print("5")
    }
    @IBAction func buttonSix(_ sender: UIButton) {
        print("6")
    }
    @IBAction func buttonSeven(_ sender: UIButton) {
        print("7")
    }
    @IBAction func buttonEight(_ sender: UIButton) {
        print("8")
    }
    @IBAction func buttonNine(_ sender: UIButton) {
        print("9")
    }
    
    @IBAction func DigitOne(_ sender: UITextField) {
    }
    @IBAction func DigitTwo(_ sender: UITextField) {
    }
    
    @IBOutlet weak var AppTitle: UILabel!
    @IBOutlet weak var DigitOne: UITextField!
    @IBOutlet weak var DigitTwo: UITextField!
    @IBOutlet weak var Result: UILabel!
    
    @IBOutlet weak var buttonClear: UIButton!
    @IBOutlet weak var buttonInvert: UIButton!
    @IBOutlet weak var buttonSquare: UIButton!
    @IBOutlet weak var buttonDivide: UIButton!
    @IBOutlet weak var buttonMultiply: UIButton!
    @IBOutlet weak var buttonSubstract: UIButton!
    @IBOutlet weak var buttonAdd: UIButton!
    @IBOutlet weak var buttonEqual: UIButton!
    @IBOutlet weak var buttonDot: UIButton!
    
    @IBOutlet weak var buttonZero: UIButton!
    @IBOutlet weak var buttonOne: UIButton!
    @IBOutlet weak var buttonTwo: UIButton!
    @IBOutlet weak var buttonThree: UIButton!
    @IBOutlet weak var buttonFour: UIButton!
    @IBOutlet weak var buttonFive: UIButton!
    @IBOutlet weak var buttonSix: UIButton!
    @IBOutlet weak var buttonSeven: UIButton!
    @IBOutlet weak var buttonEight: UIButton!
    @IBOutlet weak var buttonNine: UIButton!
    
}

