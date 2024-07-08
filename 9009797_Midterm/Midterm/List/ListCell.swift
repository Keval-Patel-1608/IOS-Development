//
//  LIstCell.swift
//  Midterm
//
//  Created by Adeesh on 2024-06-28.
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

    @IBOutlet weak var viewPriority: UIView!
    
    static var identifier = String(describing: ListCell.self)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.viewBg.addDropShadow(shadowColor: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1).cgColor, shadowOffset:CGSizeMake(2, -2), shadowRadius: 2)
        self.viewPriority.layer.cornerRadius = self.viewPriority.frame.width / 2
        self.viewPriority.addDropShadow(shadowColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).cgColor)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.updateCornerRadius()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // Reset any states
    }
    
    func configureCell(objTask: Task) {
        self.lblTitle.text = objTask.title ?? ""
        self.lblDescription.text = objTask.taskDescription ?? ""
        
        if let strDate = objTask.strDate {
            let dateValue = strDate.split(separator: "-")
            if dateValue.count >= 3 {
                self.lblDate.text = dateValue[0].description
                self.lblMonthYear.text = dateValue[1].description + " " + dateValue[2].description
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
            self.lblStatus.textColor = .red
        case .completed:
            self.lblStatus.textColor = .green
        case .ongoing:
            self.lblStatus.textColor = .orange
        case .none:
            break
        }
        
        self.viewPriority.hexStringToUIColor(hex: objTask.color?.color ?? "")
        self.updateCornerRadius()
    }

    
    private func updateCornerRadius() {
        self.viewDate.cornerRadiusWithPath()
    }
}
