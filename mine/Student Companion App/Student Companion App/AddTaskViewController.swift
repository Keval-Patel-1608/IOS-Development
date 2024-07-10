//
//  AddTaskViewController.swift
//  Student Companion App
//
//  Created by user244717 on 7/9/24.
//

import UIKit

class AddTaskViewController: UIViewController {

    @IBOutlet weak var taskTitle: UITextField!
    @IBOutlet weak var taskDescription: UITextView!
    @IBOutlet weak var dueDate: UITextField!
    @IBOutlet weak var taskImage: UIImageView!
    @IBOutlet weak var createTask: UIButton!

    // Variables for image/icon selection (you can customize this further)
    var selectedImage: UIImage?
    var selectedIcon: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up UI colors as per requirements
//        view.backgroundColor = UIColor(hex: "#FFFFFF") // White background

        // Configure taskDescription TextView
        taskDescription.layer.borderWidth = 1
        taskDescription.layer.borderColor = UIColor.lightGray.cgColor
        taskDescription.layer.cornerRadius = 5
        
        // Add tap gesture recognizer to dismiss keyboard when tapping outside text fields
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

    // Function to dismiss keyboard
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    // Validate and create task
    @IBAction func createTaskTapped(_ sender: UIButton) {
        guard let title = taskTitle.text, !title.isEmpty else {
            showAlert(message: "Please enter a task title.")
            return
        }
        guard let dueDateString = dueDate.text, !dueDateString.isEmpty else {
            showAlert(message: "Please enter a due date.")
            return
        }
        
        // Additional validation can be added for dueDate format or other fields

        // Assuming you have a Task struct or class to store task details
        let task = Task(title: title, description: taskDescription.text, dueDate: dueDateString, image: selectedImage, icon: selectedIcon)

        // Assuming you have a delegate or closure to pass back the created task
        taskCreatedDelegate?.taskCreated(task)

        // Optionally, show success message or navigate back
        navigationController?.popViewController(animated: true)
    }

    // Function to show alert
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    // Function to handle image/icon selection
    @IBAction func selectImageTapped(_ sender: UIButton) {
        // Implement image/icon selection logic here using UIImagePickerController or other methods
    }
}

