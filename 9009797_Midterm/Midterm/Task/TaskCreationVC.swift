//
//  TaskCreationVC.swift
//  Midterm
//
//  Created by Adeesh on 2024-06-28.
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
        self.configureCollectionView()
    }
    
    //MARK: - User Function
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
    
    private func configureCollectionView() {
        self.collColor.register(UINib(nibName: "ColorCell", bundle: nil), forCellWithReuseIdentifier: "ColorCell")
        self.collColor.delegate = self
        self.collColor.dataSource = self
        
        self.arrColor.append(TaskColor(color: "#FF2D00", isSeleted: false))
        self.arrColor.append(TaskColor(color: "#FBFF00", isSeleted: false))
        self.arrColor.append(TaskColor(color: "#27FF00", isSeleted: false))
        self.arrColor.append(TaskColor(color: "#0061FF", isSeleted: false))
        self.arrColor.append(TaskColor(color: "#00E8FF", isSeleted: false))
        self.arrColor.append(TaskColor(color: "#D100FF", isSeleted: false))
        self.arrColor.append(TaskColor(color: "#FFB900", isSeleted: false))
        self.collColor.reloadData()
    }
    
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
    
    @objc func doneButtonPressed() {
        if let datePicker = self.txtDate.inputView as? UIDatePicker {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            self.selectedDate = datePicker.date
            self.txtDate.text = dateFormatter.string(from: datePicker.date)
        }
        self.txtDate.resignFirstResponder()
    }
    
    @IBAction func btnUploadImageClicked(_ sender: UIButton) {
        self.openImagePickerView()
    }
    
    @IBAction func btnDeleteImageClicked(_ sender: UIButton) {
        self.viewUploadImage.isHidden = false
        self.viewImage.isHidden = true
    }
    
    @IBAction func btnTaskCreateClicked(_ sender: UIButton) {
        
        let colorValue = self.arrColor.first( where: { $0.isSeleted == true })
        if self.txtTitle.text != "" {
            if (self.txtDescription.text != "" && self.txtDescription.text != "Please type description here...") {
                if self.txtDate.text != "" {
                    if colorValue != nil {
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
                    } else {
                        self.showSimpleAlert(title: "Please set priority by selecting color.")
                    }
                } else {
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
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Please type description here..."
            textView.textColor = UIColor.lightGray
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        _ = self.arrColor.map { $0.isSeleted = false }
        self.arrColor[indexPath.item].isSeleted = true
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 30, height: 30)
    }
    
}

//MARK: - UIImagePickerController Delegate
extension TaskCreationVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func openImagePickerView() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            self.viewUploadImage.isHidden = true
            self.viewImage.isHidden = false
            self.imgTask.image = image
        }
        dismiss(animated: true, completion: nil)
    }
}

