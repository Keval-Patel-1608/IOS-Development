//
//  ToDoVC.swift
//  Lab6_Tableview
//
//  Created by user244 on 2024-07-06.
//

import UIKit

class ToDoVC: UIViewController {

    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var btnSelectSection: UIButton!
    @IBOutlet weak var txtItem: UITextField!
    
    @IBOutlet weak var addNewSection: UIButton!
    
    @IBOutlet weak var tblToDo: UITableView!
    @IBOutlet weak var viewBgPicker: UIView!
    @IBOutlet weak var viewBgPickerHeight: NSLayoutConstraint!
    @IBOutlet weak var btnPickerDone: UIButton!
    @IBOutlet weak var sectionPicker: UIPickerView!
    
    
    var arrToDos: [String: [String]] = ["Kitchen Chores": ["Wash Dishes", "Clean Cuntertops"], "Outdoor Chores": ["Mow the Lawn", "Water Plants", "Dispose Garbage"]]
    
    var sections: [String] {
        return Array(arrToDos.keys)
    }
    var selectedSection = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureNavigation()
        self.configureOutlets()
        
        self.tblToDo.delegate = self
        self.tblToDo.dataSource = self
        self.tblToDo.register(UINib(nibName: ToDoTBLCell.identifier, bundle: nil), forCellReuseIdentifier: ToDoTBLCell.identifier)
        
        self.sectionPicker.delegate = self
        self.sectionPicker.dataSource = self
    }

    private func configureNavigation() {
        self.title = "To Do"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addSection))
    }
    private func configureOutlets() {
        self.viewTop.addDropShadow(shadowColor: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1).cgColor)
        self.viewBgPickerHeight.constant = 0
        self.viewBgPicker.isHidden = true
        
    }
    
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
    
    @IBAction func btnActionClicked(_ sender: UIButton) {
        if sender.tag == 1 {
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
            self.btnSelectSection.setTitle("Select Section", for: .normal)
            self.txtItem.text = ""
        }
    }
}

extension ToDoVC {
    @IBAction func btnSelectSectionClicked(_ sender: UIButton) {
        self.viewBgPicker.isHidden = false
        UIView.animate(withDuration: 0.5) {
            self.viewBgPickerHeight.constant = UIScreen.main.bounds.height
            self.viewBgPicker.alpha = 1
        } completion: { _ in
            
        }
    }
    
    @IBAction func btnPickerDoneClicked(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5) {
            self.viewBgPickerHeight.constant = 0
            self.viewBgPicker.alpha = 0
        } completion: { _ in
            self.viewBgPicker.isHidden = true
        }

    }
}
//MARK: - UITableview Delegate and DataSource
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

//MARK: - UIPickerView DataSource and Delegate
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
