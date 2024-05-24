//
//  ViewController.swift
//  UserInputForm
//
//  Created by user244717 on 5/23/24.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtCountry: UITextField!
    @IBOutlet weak var txtAge: UITextField!
    @IBOutlet weak var txtArea: UITextView!
    @IBOutlet weak var labelMessage: UILabel!
    
    @IBAction func buttonAdd(_ sender: UIButton) {
        self.txtArea.isHidden = false
        self.txtArea.text = "\n\nFull Name : \(self.txtFirstName.text!) \(self.txtLastName.text!)\nCountry : \(self.txtCountry.text!)\nAge : \(self.txtAge.text!)"
    }
    @IBAction func buttonSubmit(_ sender: UIButton) {
        if self.txtFirstName.text == "" || self.txtLastName.text == "" || self.txtCountry.text == "" || self.txtAge.text == ""{
            self.labelMessage.text = "Complete The Missing Info!"
        }else {
            self.labelMessage.text = "Successfully Submitted"
        }
            
    }
    @IBAction func buttonClear(_ sender: UIButton) {
        self.txtArea.isHidden = true
        self.txtFirstName.text = ""
        self.txtLastName.text = ""
        self.txtCountry.text = ""
        self.txtAge.text = ""
        self.txtArea.text = ""
        self.labelMessage.text = ""
    }
    
}

