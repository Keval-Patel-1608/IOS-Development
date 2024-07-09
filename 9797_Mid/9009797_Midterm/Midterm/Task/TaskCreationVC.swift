//
//  TaskCreationVC.swift
//  Midterm
//
//  Created by Admin on 2024-06-28.
//

import UIKit

class TaskCreationVC: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtDescription: UITextView!
    @IBOutlet weak var txtDate: UITextField!
    @IBOutlet weak var collColor: UICollectionView!
    @IBOutlet weak var uploadImageView: UIView!
    @IBOutlet weak var btnDeleteImage: UIButton!
    @IBOutlet weak var imgTask: UIImageView!
    @IBOutlet weak var viewImage: UIView!
    @IBOutlet weak var viewUploadImage: UIView!
    @IBOutlet weak var btnCreateTask: UIButton!
    
    
    
    //MARK: - Variable
    var arrColor = [TaskColor]()
    var selectedDate: Date?
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureOutlets()
//        self.configureCollectionView()
    }
    
    //MARK: - User Function
    // Configures the outlets and initial view setup
    private func configureOutlets() {
        self.navigationItem.title = "Abc"
        self.txtTitle.delegate = self
        self.uploadImageView.addDashedBorder()
        self.bgView.addDropShadow()
        self.btnCreateTask.layer.cornerRadius = 20
        self.btnCreateTask.addDropShadow()
        self.txtDescription.delegate = self
        self.txtDescription.text = "Please type description here..."
        self.txtDescription.textColor = UIColor.lightGray
        
        self.txtDate.addInputViewDatePicker(target: self, selector: #selector(doneButtonPressed))
    }
 
    
    // Resets the values of all input fields and UI elements
    func resetValue() {
        self.txtTitle.text = ""
        self.txtDescription.text = "Please type description here..."
        self.txtDescription.textColor = UIColor.lightGray
        self.txtDate.text = ""
        _ = self.arrColor.map { $0.isSeleted = false }
        self.imgTask.image = nil
        self.viewUploadImage.isHidden = false
        self.viewImage.isHidden = true
        self.collColor.reloadData()
    }
    
}

//MARK: - Button Action
extension TaskCreationVC {
    
    // Handles the done button press on the date picker input view
    @objc func doneButtonPressed() {
        if let datePicker = self.txtDate.inputView as? UIDatePicker {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            self.selectedDate = datePicker.date
            self.txtDate.text = dateFormatter.string(from: datePicker.date)
        }
        self.txtDate.resignFirstResponder()
    }
    
    // Opens the image picker when the upload image button is clicked
    @IBAction func btnUploadImageClicked(_ sender: UIButton) {
        self.openImagePickerView()
    }
    
    // Deletes the selected image when the delete image button is clicked
    @IBAction func btnDeleteImageClicked(_ sender: UIButton) {
        self.viewUploadImage.isHidden = false
        self.viewImage.isHidden = true
    }
    
    // Handles the task creation logic when the create task button is clicked
    @IBAction func btnTaskCreateClicked(_ sender: UIButton) {
        
        let colorValue = self.arrColor.first( where: { $0.isSeleted == true })
        if self.txtTitle.text != "" {
            if (self.txtDescription.text != "" && self.txtDescription.text != "Please type description here...") {
                if self.txtDate.text != "" {
//                    if colorValue != nil {
                        if self.viewImage.isHidden == false {
                            
                            //retrive Data
                            var arrTasks = CustomGlobal.shared.retriveItemsFromPreference() ?? []
                            let objValue = Task(title: self.txtTitle.text, taskDescription: self.txtDescription.text, strDate: self.txtDate.text, dateValue: selectedDate, color: colorValue, image: CustomGlobal.shared.convertImageToBase64String(img: self.imgTask.image ?? UIImage()), status: .pending)
                            arrTasks.append(objValue)
                            
                            //Saving Data
                            CustomGlobal.shared.storingItemsInPreferences(arrayValue: arrTasks)
                            
                            self.showSimpleAlert(title: "Task Created Successfully...")
                            self.resetValue()
                        } else {
                            self.showSimpleAlert(title: "Please select image.")
                        }
                    }
                else {
                    self.showSimpleAlert(title: "Please enter date.")
                }
            } else {
                self.showSimpleAlert(title: "Please enter description.")
            }
        } else {
            self.showSimpleAlert(title: "Please enter title.")
        }
    }
}

//MARK: - UITextField and UITextView Delegate
extension TaskCreationVC: UITextViewDelegate, UITextFieldDelegate {
    // Clears the placeholder text when the user begins editing the description text view
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    // Sets the placeholder text if the description text view is empty when editing ends
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Please type description here..."
            textView.textColor = UIColor.lightGray
        }
    }
    
    // Dismisses the keyboard when the return key is pressed in the description text view
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    // Dismisses the keyboard when the return key is pressed in the title text field
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

//MARK: - UICollectionView Delegate and DataSource
extension TaskCreationVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrColor.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCell", for: indexPath) as? ColorCell else { return UICollectionViewCell() }
        cell.configureCell(value: self.arrColor[indexPath.item])
        return cell
    }
    
    // Updates the selected color when a color cell is tapped
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        _ = self.arrColor.map { $0.isSeleted = false }
        self.arrColor[indexPath.item].isSeleted = true
        collectionView.reloadData()
    }
    
    // Sets the size for each color cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 30, height: 30)
    }
    
}

//MARK: - UIImagePickerController Delegate
extension TaskCreationVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // Opens the image picker to select an image from the photo library
    func openImagePickerView() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    // Handles the image selection from the image picker
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            self.viewUploadImage.isHidden = true
            self.viewImage.isHidden = false
            self.imgTask.image = image
        }
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func dismissKeyboard(_sender: UITapGestureRecognizer) {
        txtTitle.resignFirstResponder()
        txtDescription.resignFirstResponder()
    }
    
    
}

