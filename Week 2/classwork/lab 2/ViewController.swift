//
//  ViewController.swift
//  lab 2
//
//  Created by user244717 on 5/13/24.
//

import UIKit

class ViewController: UIViewController {

    
    @IBAction func buttonMinus(_ sender: UIButton) {
        print("Minus")
    }
    @IBAction func buttonPlus(_ sender: UIButton) {
        print("Add")
    }
    @IBOutlet weak var labelValue: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }	


}

