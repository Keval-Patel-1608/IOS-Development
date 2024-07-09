//
//  SettingHeaderView.swift
//  Midterm
//
//  Created by Admin on 2024-07-05.
//

import UIKit

// Custom UITableViewHeaderFooterView for displaying the header section in the settings table view
class SettingHeaderView: UITableViewHeaderFooterView {

    @IBOutlet weak var lblTitle: UILabel!
    
    // Static identifier for the header view
    static let identiifier = String(describing: SettingHeaderView.self)
    
}
