//
//  ViewController.swift
//  AutoLayout
//
//  Created by user244717 on 5/30/24.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.textBirthDate.delegate = self
        
        clickAcceptButton.isEnabled = false
            [textFirstName, textSurname, textAddress, textCity, textBirthDate].forEach({ $0.addTarget(self, action: #selector(editingChanged), for: .editingChanged) })

    }
    
    @IBOutlet weak var textFirstName: UITextField!
    @IBOutlet weak var textSurname: UITextField!
    @IBOutlet weak var textAddress: UITextField!
    @IBOutlet weak var textCity: UITextField!
    @IBOutlet weak var textBirthDate: UITextField!
        
    @IBOutlet weak var textViewArea: UITextView!
    
    @IBOutlet weak var clickAcceptButton: UIButton!
    
    private func clearAllFields() {
        self.textFirstName.text = ""
        self.textSurname.text = ""
        self.textAddress.text = ""
        self.textCity.text = ""
        self.textBirthDate.text = ""
        self.textViewArea.text = ""
    }
    
    @objc func editingChanged(_ textField: UITextField) {
//        sender.text = sender.text?.trimmingCharacters(in: .whitespaces)

        guard
            let fname = textFirstName.text, !fname.isEmpty,
            let sname = textSurname.text, !sname.isEmpty,
            let address = textAddress.text, !address.isEmpty,
            let city = textCity.text, !city.isEmpty,
            let dob = textBirthDate.text, !dob.isEmpty
        else {
            clickAcceptButton.isEnabled = false
            return

        }
//        self.checkAge(<#T##textField: UITextField##UITextField#>)
//        textFieldDidEndEditing(<#T##UITextField#>)
        let testformatter = DateFormatter()
        testformatter.dateFormat = "dd/MM/yyyy"
        let date = testformatter.date(from: self.textBirthDate.text ?? "")
        var age = 0
        age = Calendar.current.dateComponents([.year], from: date ?? Date(), to: Date()).year ?? 0
        if age >= 18 {
            self.textViewArea.text = "I, \(self.textFirstName.text ?? "") \(self.textSurname.text ?? ""), currently living at \(self.textAddress.text ?? "") in the city of \(self.textCity.text ?? "") do hereby accept the terms and conditions assignment. \n\nI am \(age) and therefore am able to accept the conditions of this assignment."
            clickAcceptButton.isEnabled = true
        } else {
            self.textViewArea.text = "Sorry, Age should be 18 or higher to accept terms."
            clickAcceptButton.isEnabled = false
        }
        
    }
    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        return true
//    }
    
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        if self.textBirthDate == textField {
//            let testformatter = DateFormatter()
//            testformatter.dateFormat = "dd/MM/yyyy"
//            let date = testformatter.date(from: self.textBirthDate.text ?? "")
//            var age = 0
//            age = Calendar.current.dateComponents([.year], from: date ?? Date(), to: Date()).year ?? 0
//            if age >= 18 {
//                self.textViewArea.text = "I, \(self.textFirstName.text ?? "") \(self.textSurname.text ?? ""), currently living at \(self.textAddress.text ?? "") in the city of \(self.textCity.text ?? "") do hereby accept the terms and conditions assignment. \n\nI am \(age) and therefore am able to accept the conditions of this assignment."
//                clickAcceptButton.isEnabled = true
//            } else {
//                self.textViewArea.text = "Sorry, Age should be 18 or higher to accept terms."
//                clickAcceptButton.isEnabled = false
//            }
//            // and add other validation
//        }
//    }
    
    @IBAction func clickDeclineButton(_ sender: UIButton) {
        self.clearAllFields()
        self.textViewArea.text = "User clicked on decline button."
    }
    @IBAction func clickAcceptButton(_ sender: UIButton) {
        if self.textFirstName.text == "" || self.textSurname.text == "" || self.textAddress.text == "" || self.textCity.text == "" || self.textBirthDate.text == "" {
            self.textViewArea.text = "Complete the all missing Info!"
        } else {
            self.textViewArea.text = "\n\nTerms and Conditions Agreed Successfully!"
        }
            
        // and add other validation
    }
    @IBAction func clickResetButton(_ sender: UIButton) {
        self.clearAllFields()
    }
    
}

