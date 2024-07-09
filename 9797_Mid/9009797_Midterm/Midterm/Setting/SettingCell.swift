//
//  SettingCell.swift
//  Midterm
//
//  Created by Admin on 2024-07-01.
//

import UIKit

// Custom UITableViewCell for displaying a setting option with a label and a switch
class SettingCell: UITableViewCell {

    @IBOutlet weak var lblSetting: UILabel!
    @IBOutlet weak var toggleSwitch: UISwitch!
    
    // Static identifier for the cell
    static let identiifier = String(describing: SettingCell.self)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    // Configure the view when a cell is selected or deselected
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // Configure the cell with data from a SettingValue object
    func cellConfiguration(obj: SettingValue) {
        if obj.isSelected == true {
            self.toggleSwitch.setOn(true, animated: false)
        } else {
            self.toggleSwitch.setOn(false, animated: false)
        }
        self.lblSetting.text = obj.value
    }
}
