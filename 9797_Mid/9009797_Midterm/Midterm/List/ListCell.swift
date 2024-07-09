//
//  LIstCell.swift
//  Midterm
//
//  Created by Admin on 2024-06-28.
//

import UIKit

class ListCell: UITableViewCell {

    @IBOutlet weak var viewBg: UIView!
    @IBOutlet weak var viewDate: UIView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblMonthYear: UILabel!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblStatus: UILabel!

    @IBOutlet weak var clipColor: UIView!
    
    static var identifier = String(describing: ListCell.self)
    
    var selectedTask: Task?

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        // Adding a drop shadow to the background view with specified properties
        self.viewBg.addDropShadow(shadowColor: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1).cgColor, shadowOffset:CGSizeMake(2, -2), shadowRadius: 2)
//        self.viewPriority.layer.cornerRadius = self.viewPriority.frame.width / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Updating corner radius for specific corners after layout
        self.updateCornerRadius()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        // Reset any states before the cell is reused
    }
    
    // Configuring the cell with the task details
    func configureCell(objTask: Task) {
        self.lblTitle.text = objTask.title ?? ""
//        print(lblTitle.text)
        self.lblDescription.text = objTask.taskDescription ?? ""
        
//        print(lblDate.text)

        if let strDate = objTask.strDate {
            let dateValue = strDate.split(separator: " ")
            if dateValue.count >= 3 {
                let date = dateValue[1].description.split(separator: ",")
                self.lblDate.text = date[0].description
                self.lblMonthYear.text = dateValue[0].description + " " + dateValue[2].description
            } else {
                self.lblDate.text = ""
                self.lblMonthYear.text = ""
            }
        } else {
            self.lblDate.text = ""
            self.lblMonthYear.text = ""
        }
        
        self.lblStatus.text = objTask.status?.rawValue
        switch objTask.status {
        case .pending:
            self.lblStatus.textColor   = .red
            self.clipColor.backgroundColor = .red
        case .completed:
            self.lblStatus.textColor = UIColor(red: 20/255, green: 150/255, blue: 20/255, alpha: 1)
            self.clipColor.backgroundColor = UIColor(red: 20/255, green: 150/255, blue: 20/255, alpha: 1)

        case .ongoing:
            self.lblStatus.textColor = .orange
            self.clipColor.backgroundColor = .orange
        case .none:
            break
        }
        
        
        self.updateCornerRadius()
    }

    // Helper method to update the corner radius of the date view

    private func updateCornerRadius() {
        self.viewDate.cornerRadiusWithPath()
    }
}
