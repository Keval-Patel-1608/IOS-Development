import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    override func viewDidLoad() {
        self.textViewArea.text = "Please fill all the missing Info!"
        super.viewDidLoad()
        
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
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        if let date = dateFormatter.date(from: dob) {
            let age = Calendar.current.dateComponents([.year], from: date, to: Date()).year ?? 0
            print(dob.count)
            if age >= 18 && dob.count == 10 {
                self.textViewArea.text = """
                I, \(fname) \(sname), currently living at \(address) in the city of \(city) do hereby accept the terms and conditions assignment.

                I am \(age) and therefore am able to accept the conditions of this assignment.
                """
                clickAcceptButton.isEnabled = true
            } else {
                self.textViewArea.text = "Sorry, Age should be 18 or higher to accept terms."
                clickAcceptButton.isEnabled = false
            }
        } else {
            self.textViewArea.text = "Please enter the birth date in dd/MM/yyyy format."
            clickAcceptButton.isEnabled = false
        }
    }
    
    @IBAction func clickDeclineButton(_ sender: UIButton) {
        self.clearAllFields()
        self.textViewArea.text = "Terms Declined."
    }
    
    @IBAction func clickAcceptButton(_ sender: UIButton) {
        self.textViewArea.text = "\n\nTerms and Conditions Agreed Successfully!"
    }
    
    @IBAction func clickResetButton(_ sender: UIButton) {
        self.clearAllFields()
    }
}

