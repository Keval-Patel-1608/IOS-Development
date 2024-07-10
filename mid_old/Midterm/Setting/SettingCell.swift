//
//  SettingCell.swift
//  Midterm
//
//  Created by Adeesh on 2024-07-01.
//

import UIKit

class SettingCell: UITableViewCell {

    @IBOutlet weak var lblSetting: UILabel!
    @IBOutlet weak var toggleSwitch: UISwitch!
    
    static let identiifier = String(describing: SettingCell.self)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func cellConfiguration(obj: SettingValue) {
        if obj.isSelected == true {
            self.toggleSwitch.setOn(true, animated: false)
        } else {
            self.toggleSwitch.setOn(false, animated: false)
        }
        self.lblSetting.text = obj.value
    }
}
