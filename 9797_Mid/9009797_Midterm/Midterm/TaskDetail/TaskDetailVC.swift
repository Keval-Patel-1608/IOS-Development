//
//  TaskDetailVC.swift
//  Midterm
//
//  Created by Admin on 2024-07-01.
//

import UIKit

class TaskDetailVC: UIViewController {

    //MARK: - Outlet
    @IBOutlet weak var imgTask: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblTaskDescription: UILabel!
    @IBOutlet weak var viewDate: UIView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblMonthYear: UILabel!
//    @IBOutlet weak var viewPriority: UIView!
    @IBOutlet weak var btnOngoing: UIButton!
    @IBOutlet weak var btnCompleted: UIButton!
    
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    //MARK: - Variable
    var selectedTask: Task?
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureOutlet()
        self.displaySelectedTaskOutlet()
    }
    
    // Configures the UI elements' appearance and properties
    //MARK: - User Function
    private func configureOutlet() {
        self.viewDate.layer.cornerRadius = 20
        self.btnOngoing.layer.cornerRadius = 20
        self.btnCompleted.layer.cornerRadius = 20
        
        self.viewDate.addDropShadow(shadowColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).cgColor)

        self.btnOngoing.addDropShadow(shadowColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).cgColor)
        self.btnCompleted.addDropShadow(shadowColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).cgColor)
        self.indicator.isHidden = true
    }
    
    // Displays the details of the selected task
    private func displaySelectedTaskOutlet() {
        self.imgTask.image = CustomGlobal.shared.convertBase64StringToImage(imageBase64String: self.selectedTask?.image ?? "")
        self.lblTitle.text = self.selectedTask?.title
        self.lblTaskDescription.text = self.selectedTask?.taskDescription
        
        // Parse the date string and set the date and month/year labels
        let dateValue = self.selectedTask?.strDate?.split(separator: "-")
        self.lblDate.text = dateValue?[0].description
        
        self.lblMonthYear.text = ""
        if let dateValue = self.selectedTask?.strDate?.split(separator: "-"), dateValue.count >= 3 {
            self.lblDate.text = dateValue[0].description
            self.lblMonthYear.text = "\(dateValue[1]) \(dateValue[2])"
        }

self.lblStatus.text = self.selectedTask?.status?.rawValue
        switch self.selectedTask?.status {
        case .pending:
            self.lblStatus.textColor = .red
        case .completed:
            self.lblStatus.textColor = .green
        case .ongoing:
            self.lblStatus.textColor = .orange
        case .none:
            break
        }
//        self.viewPriority.hexStringToUIColor(hex: self.selectedTask?.color?.color ?? "")
        
        // Configure button states based on task status
        if selectedTask?.status == .pending {
            self.btnOngoing.isEnabled = true
            self.btnCompleted.isEnabled = true
            self.btnOngoing.alpha = 1
            self.btnCompleted.alpha = 1
        } else if selectedTask?.status == .ongoing {
            self.btnOngoing.isEnabled = false
            self.btnCompleted.isEnabled = true
            
            self.btnOngoing.alpha = 0.5
            self.btnCompleted.alpha = 1
        } else {
            self.btnOngoing.isEnabled = false
            self.btnCompleted.isEnabled = false
            
            self.btnOngoing.alpha = 0.5
            self.btnCompleted.alpha = 0.5
        }
    }
    
    // Updates the task status to ongoing or completed
    private func updateTaskObjectValue(isOngoing: Bool) {
        var arrTask = CustomGlobal.shared.retriveItemsFromPreference()
        if let index = arrTask?.firstIndex(where:  {$0.taskId == self.selectedTask?.taskId}) {
            if isOngoing {
                arrTask?[index].status = .ongoing
                self.btnOngoing.isEnabled = false
                self.btnCompleted.isEnabled = true
                
                self.btnOngoing.alpha = 0.5
                self.btnCompleted.alpha = 1
                
                self.lblStatus.text = TaskStatus.ongoing.rawValue
                self.lblStatus.textColor = .orange
                
            } else {
                arrTask?[index].status = .completed
                
                self.btnOngoing.isEnabled = false
                self.btnCompleted.isEnabled = false
                
                self.btnOngoing.alpha = 0.5
                self.btnCompleted.alpha = 0.5
                self.lblStatus.text = TaskStatus.completed.rawValue
                self.lblStatus.textColor = .green
            }
            CustomGlobal.shared.storingItemsInPreferences(arrayValue: arrTask ?? [])
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                self.indicator.isHidden = true
                self.indicator.stopAnimating()
            }
            
            self.showSimpleAlert(title: "Task Updated Successfully")
        }
    }
    
    
    //MARK: - Button Action
    @IBAction func btnBackClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnTaskClicked(_ sender: UIButton) {
        self.indicator.isHidden = false
        self.indicator.startAnimating()
        switch sender.tag {
        case 1:
            print("Ongoing")
            self.updateTaskObjectValue(isOngoing: true)
        default:
            print("Completed")
            self.updateTaskObjectValue(isOngoing: false)
        }
    }
}
