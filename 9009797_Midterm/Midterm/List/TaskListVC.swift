//
//  TaskListVC.swift
//  Midterm
//
//  Created by Adeesh on 2024-06-28.
//

import UIKit

class TaskListVC: UIViewController {

    //MARK: - Outlet
    @IBOutlet weak var viewBG: UIView!
    @IBOutlet weak var tblList: UITableView!
    @IBOutlet weak var lblNoTask: UILabel!
    
    //MARK: - Variable
    var arrTask = [Task]()
    var arrFilterTask:[Task]?
    var selectedValues = [SettingValue]()
    var isNeedToCall = true
    
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewBG.addDropShadow()
        self.configureTableView()
        self.checkForReminders()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isNeedToCall {
            self.arrTask = CustomGlobal.shared.retriveItemsFromPreference() ?? []
            if self.arrTask.count == 0 {
                self.hideTableView(isHidden: true)
            } else {
                self.hideTableView(isHidden: false)
                self.tblList.reloadData()
            }
        }
        
    }
    
    //MARK: - User Function
    private func configureTableView() {
        self.tblList.delegate = self
        self.tblList.dataSource = self
        
        self.tblList.register(UINib(nibName: ListCell.identifier, bundle: nil), forCellReuseIdentifier: ListCell.identifier)
    }
    
    func hideTableView(isHidden: Bool) {
        if isHidden {
            self.tblList.isHidden = true
            self.lblNoTask.isHidden = false
        } else {
            self.tblList.isHidden = false
            self.lblNoTask.isHidden = true
        }
    }
    
    func checkForReminders() {
        for obj in CustomGlobal.shared.retriveItemsFromPreference() ?? [] {
            if Calendar.current.isDateInToday(obj.dateValue ?? Date()) {
                self.showReminderAlert(task: obj)
            }
        }
    }

    func showReminderAlert(task: Task) {
        let alert = UIAlertController(title: "Reminder", message: "Task \(task.title ?? "") is due today!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

//MARK: - Button Action
extension TaskListVC {
    @IBAction func btnFliterClicked(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let settingViewController = storyboard.instantiateViewController(withIdentifier: "SettingVC") as! SettingVC
        settingViewController.selectedValues = self.selectedValues
        settingViewController.filterValueReturn = { [weak self] array, selectedValues in
            self?.selectedValues = selectedValues ?? []
            self?.isNeedToCall = false
            self?.arrTask = array ?? []
            if self?.arrTask.isEmpty == true {
                self?.hideTableView(isHidden: true)
            } else {
                self?.hideTableView(isHidden: false)
            }
            self?.tblList.reloadData()
        }
        self.navigationController?.pushViewController(settingViewController, animated: true)
    }
}

//MARK: - UITableView Delegate and DataSource
extension TaskListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrTask.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListCell.identifier, for: indexPath) as? ListCell else { return UITableViewCell() }
        
        cell.configureCell(objTask: self.arrTask[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.showSimpleAlertWithCancelOption(title: "Are you sure you want to delete?") { isCancel in
                if isCancel == false {
                    
                    let originalArray = CustomGlobal.shared.retriveItemsFromPreference() ?? []
                    let objDelete = self.arrTask[indexPath.row]
                    var temp = [Task]()
                    originalArray.forEach { obj in
                        if obj.taskId != objDelete.taskId {
                            temp.append(obj)
                        }
                    }
                    self.arrTask.remove(at: indexPath.row)
                    CustomGlobal.shared.storingItemsInPreferences(arrayValue: temp)
                    
                    self.tblList.deleteRows(at: [indexPath], with: .fade)
                    if self.arrTask.isEmpty == true {
                        self.hideTableView(isHidden: true)
                    }
            
                }
                self.dismiss(animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.isNeedToCall = true
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailViewController = storyboard.instantiateViewController(withIdentifier: "TaskDetailVC") as! TaskDetailVC
        detailViewController.selectedTask = self.arrTask[indexPath.row]
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
}
