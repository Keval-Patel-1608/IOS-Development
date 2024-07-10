//
//  CreateViewController.swift
//  MidtermApp
//
//  Created by Keval on 8/3/24.
//
import QuartzCore
import UIKit

class CreateViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var titleText: UITextField!
    @IBOutlet weak var descText: UITextField!
    @IBOutlet weak var dateText: UITextField!
    @IBOutlet weak var imageTask: UIImageView!
    
    @IBOutlet weak var statusLabel: UILabel!
    var pickerDate: UIDatePicker!
    var selectedStatus: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Task"

        pickerDate = UIDatePicker()
        pickerDate.datePickerMode = .date
        pickerDate.preferredDatePickerStyle = .wheels
        pickerDate.minimumDate = Date()
        pickerDate.addTarget(self, action: #selector(setDate), for: .valueChanged)
        dateText.inputView = pickerDate
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneDatePicker))
        toolbar.setItems([done], animated: true)
        dateText.inputAccessoryView = toolbar
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageTask.image = image
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func taskSaveTapped(_ sender: UIButton) {
        if titleText.text != "" {
            if descText.text != "" {
                if dateText.text != "" {
                    if  self.statusLabel.text != "" {
                        let formatter = DateFormatter()
                        formatter.dateFormat = "dd/MMM/yyyy"
                        let strDate = formatter.string(from: pickerDate.date)
                        
                        let newTask = TaskModel(title: titleText.text ?? "", description: descText.text ?? "", dueDate: pickerDate.date, strDate: strDate, status:  self.statusLabel.text ?? "", image: imageTask.image ?? UIImage())
                        TaskHandler.shared.addTask(newTask)
                        showAlert(message: "Task saved successfully!")
                        titleText.text = ""
                        descText.text = ""
                        dateText.text = ""
                        imageTask.image = nil

                    } else {
                        showAlert(message: "Status is required")
                    }
                } else {
                    showAlert(message: "Enter Date")
                }
                
            } else {
                showAlert(message: "Enter Description")
            }
        } else {
            showAlert(message: "Enter title")
        }
    }
    
    @IBAction func imageAddButton(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default))
        present(alert, animated: true)
    }
    
    @objc func doneDatePicker() {
        view.endEditing(true)
    }
    
    @objc func setDate() {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy"
        dateText.text = formatter.string(from: pickerDate.date)
    }
    
    @IBAction func statusAddButton(_ sender: Any) {
        let alert = UIAlertController(title: "Select Status", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Complete", style: .default, handler: { _ in
            self.statusLabel.text = "Complete"
        }))
        
        
        alert.addAction(UIAlertAction(title: "Pending", style: .default, handler: { _ in
            self.statusLabel.text = "Pending"
        }))
        present(alert, animated: true)
    }
}

