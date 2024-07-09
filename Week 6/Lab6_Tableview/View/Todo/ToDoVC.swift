//
//  ToDoVC.swift
//  Lab6_Tableview
//
//  Created by user244 on 2024-07-06.
//

import UIKit

class ToDoVC: UIViewController {

    // Outlets
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var btnSelectSection: UIButton!
    @IBOutlet weak var txtItem: UITextField!
    @IBOutlet weak var addNewSection: UIButton!
    @IBOutlet weak var tblToDo: UITableView!
    @IBOutlet weak var viewBgPicker: UIView!
    @IBOutlet weak var viewBgPickerHeight: NSLayoutConstraint!
    @IBOutlet weak var btnPickerDone: UIButton!
    @IBOutlet weak var sectionPicker: UIPickerView!
    
    // Data
    var arrToDos: [String: [String]] = [
        "Kitchen Chores": ["Wash Dishes", "Clean Countertops"],
        "Outdoor Chores": ["Mow the Lawn", "Water Plants", "Dispose Garbage"],
        "Office Chores": ["New Project Demo", "Client Meeting", "Prepare for Standup"]
    ]
    
    // Computed property to get section names
    var sections: [String] {
        return Array(arrToDos.keys)
    }
    
    var selectedSection = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set up initial configurations
        self.configureNavigation()
        self.configureOutlets()
        
        // Set table view delegate and data source
        self.tblToDo.delegate = self
        self.tblToDo.dataSource = self
        self.tblToDo.register(UINib(nibName: ToDoTBLCell.identifier, bundle: nil), forCellReuseIdentifier: ToDoTBLCell.identifier)
        
        // Set picker view delegate and data source
        self.sectionPicker.delegate = self
        self.sectionPicker.dataSource = self
    }

    // Configure navigation bar
    private func configureNavigation() {
        self.title = "To Do"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addSection))
    }
    
    // Configure initial appearance of UI elements
    private func configureOutlets() {
        self.viewTop.addDropShadow(shadowColor: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1).cgColor)
        self.viewBgPickerHeight.constant = 0
        self.viewBgPicker.isHidden = true
    }
    
    // Action to add a new section
    @objc func addSection() {
        let alert = UIAlertController(title: "New Section", message: "", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Section Name"
        }
        
        let addAction = UIAlertAction(title: "Add", style: .default) { _ in
            if let sectionName = alert.textFields?.first?.text, !sectionName.isEmpty {
                self.arrToDos[sectionName] = []
                self.tblToDo.reloadData()
                self.sectionPicker.reloadAllComponents()
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        
        alert.addAction(cancelAction)
        alert.addAction(addAction)
        present(alert, animated: true, completion: nil)
    }
    
    // Action when buttons are clicked (Add Task and Cancel)
    @IBAction func btnActionClicked(_ sender: UIButton) {
        if sender.tag == 1 {
            // Add Task button clicked
            if btnSelectSection.titleLabel?.text != "Select Section" {
                if self.txtItem.text != "" {
                    self.arrToDos[self.selectedSection]?.append(self.txtItem.text ?? "")
                    self.tblToDo.reloadData()
                    self.btnSelectSection.setTitle("Select Section", for: .normal)
                    self.txtItem.text = ""
                } else {
                    self.showSimpleAlert(title: "Please enter todo task.")
                }
            } else {
                self.showSimpleAlert(title: "Please select section")
            }
        } else {
            // Cancel button clicked
            self.btnSelectSection.setTitle("Select Section", for: .normal)
            self.txtItem.text = ""
        }
    }
}

//MARK: - Extension for additional functionalities

extension ToDoVC {
    
    // Handle when Select Section button is clicked
    @IBAction func btnSelectSectionClicked(_ sender: UIButton) {
        self.viewBgPicker.isHidden = false
        UIView.animate(withDuration: 0.5) {
            self.viewBgPickerHeight.constant = UIScreen.main.bounds.height
            self.viewBgPicker.alpha = 1
        } completion: { _ in
            
        }
    }
    
    // Handle when Done button in picker view is clicked
    @IBAction func btnPickerDoneClicked(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5) {
            self.viewBgPickerHeight.constant = 0
            self.viewBgPicker.alpha = 0
        } completion: { _ in
            self.viewBgPicker.isHidden = true
        }
    }
}

//MARK: - Extension for UITableViewDelegate and UITableViewDataSource

extension ToDoVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let key = self.sections[section]
        return self.arrToDos[key]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ToDoTBLCell.identifier, for: indexPath) as? ToDoTBLCell else { return UITableViewCell() }
        let key = self.sections[indexPath.section]
        cell.configureCell(value: self.arrToDos[key]?[indexPath.row] ?? "")
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sections[section]
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let key = self.sections[indexPath.section]
            self.arrToDos[key]?.remove(at: indexPath.row)
            self.tblToDo.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

//MARK: - Extension for UIPickerViewDelegate and UIPickerViewDataSource

extension ToDoVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.sections.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.sections[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedSection = self.sections[row]
        self.btnSelectSection.setTitle(self.selectedSection, for: .normal)
    }
}
