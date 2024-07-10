//
//  SettingViewController.swift
//  MidtermApp
//
//  Created by Keval on 8/3/24.
//
import QuartzCore
import UIKit

class SettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var settingTable: UITableView!

    let arrSections = ["Sort by Date", "Sort by Status"]
    let sortingDateOptions = ["Ascending", "Descending"]
    let filterStatusOptions = ["All Task","Pending", "Completed"]

    var selectedSortingDate: Int? = UserDefaults.standard.object(forKey: "sortdate") as? Int
    var selectedFilterStatus: Int? = UserDefaults.standard.object(forKey: "statusFilter") as? Int

    override func viewDidLoad() {
        super.viewDidLoad()
        settingTable.delegate = self
        settingTable.dataSource = self
    }

    @IBAction func clearButtonClick(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "sortdate")
        UserDefaults.standard.removeObject(forKey: "statusFilter")
        selectedSortingDate = nil
        selectedFilterStatus = nil
        settingTable.reloadData()
        
        NotificationCenter.default.post(name: Notification.Name("SortAndFilterChanged"), object: nil)
        
        let alertController = UIAlertController(title: "Success", message: "Sorting and filtering cleared.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }

    @IBAction func applyButtonClick(_ sender: Any) {
        
        if let selectedSortingByDate = selectedSortingDate {
            UserDefaults.standard.set(selectedSortingByDate, forKey: "sortdate")
        }
        
        if let selectedFilterByStatus = selectedFilterStatus {
            UserDefaults.standard.set(selectedFilterByStatus, forKey: "statusFilter")
        }
    
        NotificationCenter.default.post(name: Notification.Name("SortAndFilterChanged"), object: nil)
    }


    func numberOfSections(in tableView: UITableView) -> Int {
        return arrSections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return sortingDateOptions.count
        case 1:
            return filterStatusOptions.count
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return arrSections[section]
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        switch indexPath.section {
        case 0:
            cell.textLabel?.text = sortingDateOptions[indexPath.row]
            cell.accessoryType = selectedSortingDate == indexPath.row ? .checkmark : .none
        case 1:
            cell.textLabel?.text = filterStatusOptions[indexPath.row]
            cell.accessoryType = selectedFilterStatus == indexPath.row ? .checkmark : .none
        default:
            break
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            selectedSortingDate = indexPath.row
        case 1:
            selectedFilterStatus = indexPath.row
        default:
            break
        }
        tableView.reloadData()
    }

    
}

