//
//  SettingVC.swift
//  Midterm
//
//  Created by Admin on 2024-07-01.
//

import UIKit

// Enum to define various filter types
enum FilterType: Int {
    case dateAscending = 1
    case dateDescending = 2
    case allTask = 3
    case pendingTask = 4
    case ongoingTask = 5
    case completedTask = 6
    case none = 0
}

// class for a setting, containing a title and an array of setting values
class Setting {
    var title: String?
    var values: [SettingValue]?
    
    init(title: String? = nil, values: [SettingValue]? = nil) {
        self.title = title
        self.values = values
    }
}

// class for a setting value, containing a value, filter type, and selection status
class SettingValue {
    var value: String?
    var filterType: FilterType?
    var isSelected: Bool?
    
    init(value: String? = nil, filterType: FilterType = .none, isSelected: Bool? = false) {
        self.value = value
        self.filterType = filterType
        self.isSelected = isSelected
    }
}

// View controller for settings
class SettingVC: UIViewController {

    
    //MARK: - Outlets
    @IBOutlet weak var tblSetting: UITableView!
    
    @IBOutlet weak var viewBg: UIView!
    @IBOutlet weak var btnApply: UIButton!
    @IBOutlet weak var btnClear: UIButton!
    //MARK: - Variable
    var selectedValues = [SettingValue]()
    var arrFilterTask = [Task]()
    var filterValueReturn:(([Task]?, [SettingValue]?)->())?
    var arrSetting = [Setting]()
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewBg.addDropShadow()
        self.configureTableview()
        self.configureDataSource()
        self.btnClear.layer.cornerRadius = 10
        self.btnClear.addDropShadow(shadowColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).cgColor)
        self.btnApply.layer.cornerRadius = 10
        self.btnApply.addDropShadow(shadowColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).cgColor)
        
    }
    
    //MARK: - User Function
    // Configure table view
    private func configureTableview() {
        self.tblSetting.delegate = self
        self.tblSetting.dataSource = self
        self.tblSetting.register(UINib(nibName: SettingCell.identiifier, bundle: nil), forCellReuseIdentifier: SettingCell.identiifier)
        self.tblSetting.register(UINib(nibName: SettingHeaderView.identiifier, bundle: nil), forHeaderFooterViewReuseIdentifier: SettingHeaderView.identiifier)
    }
    
    // Configure data source for settings
    private func configureDataSource() {
        
        self.arrFilterTask = CustomGlobal.shared.retriveItemsFromPreference() ?? []
        
        var arrValue = [SettingValue]()
        arrValue.append(SettingValue(value: "Date Ascending", filterType: .dateAscending, isSelected: false))
        arrValue.append(SettingValue(value: "Date Descending", filterType: .dateDescending, isSelected: false))
        self.arrSetting.append(Setting(title: "Sort", values: arrValue))
        
        var arrFilterValue = [SettingValue]()
        arrFilterValue.append(SettingValue(value: "All Task", filterType: .allTask, isSelected: false))
        arrFilterValue.append(SettingValue(value: "Pending", filterType: .pendingTask, isSelected: false))
        arrFilterValue.append(SettingValue(value: "Ongoing", filterType: .ongoingTask, isSelected: false))
        arrFilterValue.append(SettingValue(value: "Completed", filterType: .completedTask, isSelected: false))
        
        self.arrSetting.append(Setting(title: "Filter", values: arrFilterValue))
        
        // Reset selection status for all settings
        _ = self.arrSetting.map { $0.values?.map {$0.isSelected = false} }
        for objSetting in self.selectedValues {
            for obj in self.arrSetting {
                if let index = obj.values?.firstIndex(where: {$0.filterType == objSetting.filterType}) {
                    obj.values?[index].isSelected = true
                }
            }
            
        }
        
        self.tblSetting.reloadData()
    }
    
    // Select filter values based on user selection
    private func selectFilterValues() -> [SettingValue] {
        var settingValues = [SettingValue]()
        
        for obj in self.arrSetting {
            for objValue in obj.values ?? [] {
                if objValue.isSelected == true {
                    settingValues.append(objValue)
                }
            }
        }
        
        return settingValues
    }
    
    // Apply the selected filters to the task list
    
    // Resource : google, stackoverflow and chatgpt (combination of all resource)
    private func doFilter() -> ([Task], [SettingValue]) {
        let filter = selectFilterValues()
        for obj in filter {
            if let filterValue = obj.filterType {
                switch filterValue {
                case .dateAscending:
                    self.arrFilterTask = self.arrFilterTask.sorted(by: { $0.dateValue?.compare($1.dateValue ?? Date()) == .orderedAscending })
                case .dateDescending:
                    self.arrFilterTask = self.arrFilterTask.sorted(by: { $0.dateValue?.compare($1.dateValue ?? Date()) == .orderedDescending })
                case .pendingTask:
                    self.arrFilterTask = self.arrFilterTask.filter { $0.status == .pending }
                case .ongoingTask:
                    self.arrFilterTask = self.arrFilterTask.filter { $0.status == .ongoing }
                case .completedTask:
                    self.arrFilterTask = self.arrFilterTask.filter { $0.status == .completed }
                case .none, .allTask:
                    print("")
                }
            }
            
        }
        
        return (self.arrFilterTask, filter)
    }
    
}
//MARK: - Button Action
extension SettingVC {
    
    // Handle back button click
    @IBAction func btnBackClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // Handle clear button click
    @IBAction func btnClearClicked(_ sender: UIButton) {
        
        _ = self.arrSetting.map { $0.values?.map {$0.isSelected = false} }
        self.filterValueReturn?(CustomGlobal.shared.retriveItemsFromPreference() ?? [], nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    // Handle apply button click
    @IBAction func btnApplyClicked(_ sender: UIButton) {
        self.filterValueReturn?(self.doFilter().0, self.doFilter().1)
        self.navigationController?.popViewController(animated: true)
    }
    
    // Handle toggle switch click
    @objc func toggleClicked(_ sender: UISwitch) {
        _ = self.arrSetting[sender.tag].values?.map { $0.isSelected = false }
        
        self.arrSetting[sender.tag].values?[Int(sender.accessibilityIdentifier ?? "0") ?? 0].isSelected = true
        
        self.tblSetting.reloadData()
    }
    
}

//MARK: - Tableview Delegate and DataSource
extension SettingVC: UITableViewDelegate, UITableViewDataSource {
    
    // Return number of sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.arrSetting.count
    }
    
    // Return number of rows in section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrSetting[section].values?.count ?? 0
    }
    
    // Configure cell for row at index path
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingCell.identiifier, for: indexPath) as? SettingCell else { return UITableViewCell() }
        if let obj = self.arrSetting[indexPath.section].values?[indexPath.row] {
            cell.cellConfiguration(obj: obj)
            cell.toggleSwitch.tag = indexPath.section
            cell.toggleSwitch.accessibilityIdentifier = "\(indexPath.row)"
            cell.toggleSwitch.addTarget(self, action: #selector(self.toggleClicked(_:)), for: .valueChanged)
        }
        
        return cell
    }
    
    // Configure header view for section
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = tableView.dequeueReusableHeaderFooterView( withIdentifier: SettingHeaderView.identiifier)! as! SettingHeaderView
        header.contentView.layer.cornerRadius = 5
        header.contentView.backgroundColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        header.lblTitle.text = self.arrSetting[section].title ?? ""
        return header
    }
    
    // Return height for header in section
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    // Return height for row at index path
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
