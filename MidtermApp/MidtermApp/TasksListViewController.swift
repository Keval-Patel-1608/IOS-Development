//
//  TasksListViewController.swift
//  MidtermApp
//
//  Created by Keval on 8/3/24.
//
import QuartzCore
import UIKit

class TaskModel: Codable {
    
    var title: String
    var desc: String
    var dueDate: Date
    var strDate: String
    var status: String
    var imgData: Data?

    init(title: String, description: String, dueDate: Date, strDate: String, status: String, image: UIImage?) {
        self.title = title
        self.imgData = image?.jpegData(compressionQuality: 0.6)
        self.desc = description
        self.dueDate = dueDate
        self.status = status
        self.strDate = strDate
    }
}

class TasksListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var arrayTasks: [TaskModel] = []
    
    @IBOutlet weak var tasksListTable: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "List"
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(sortTapped))
    
        tasksListTable.delegate = self
        tasksListTable.dataSource = self
        
        arrayTasks = TaskHandler.shared.getTasks()
        self.tasksListTable.reloadData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(sortAndFilterPreferencesChanged), name: Notification.Name("SortAndFilterChanged"), object: nil)
    }
    
    @objc func sortTapped() {
        let settingVC = storyboard?.instantiateViewController(withIdentifier: "SettingViewController") as! SettingViewController
        navigationController?.pushViewController(settingVC, animated: true)
    }

    @objc func sortAndFilterPreferencesChanged() {
        sortAndFilterTasks()
        self.tasksListTable.reloadData()
    }

    func sortAndFilterTasks() {
        arrayTasks = TaskHandler.shared.getTasks()
    
        let filterStatus = UserDefaults.standard.integer(forKey: "statusFilter")
        
    
        if filterStatus == 1 {
            arrayTasks = arrayTasks.filter { $0.status == "Pending" }
        } else if filterStatus == 2 {
            arrayTasks = arrayTasks.filter { $0.status == "Complete" }
        }
        
        
        let sortDate = UserDefaults.standard.integer(forKey: "sortdate")
        if sortDate == 0 {
            arrayTasks.sort { $0.dueDate < $1.dueDate }
        } else if sortDate == 1 {
            arrayTasks.sort { $0.dueDate > $1.dueDate }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayTasks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TaskTableViewCell
        let task = arrayTasks[indexPath.row]
        cell.labelTitle.text = task.title
        cell.labelDate.text = task.strDate
        cell.labelStatus.text = task.status
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            TaskHandler.shared.removeTask(at: indexPath.row)
            arrayTasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedTask = arrayTasks[indexPath.row]
        let detailvc = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        detailvc.task = selectedTask
        navigationController?.pushViewController(detailvc, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
 
}

