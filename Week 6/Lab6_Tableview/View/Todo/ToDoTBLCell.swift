//
//  ToDoTBLCell.swift
//  Lab6_Tableview
//
//  Created by user244 on 2024-07-06.
//

import UIKit

class ToDoTBLCell: UITableViewCell {

    @IBOutlet weak var viewBg: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    
    static let identifier = String(describing: ToDoTBLCell.self)
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(value: String) {
        self.viewBg.layer.cornerRadius = 10
        self.viewBg.backgroundColor = UIColor(red: 225/255, green: 216/255, blue: 225/255, alpha: 1)
        self.lblTitle.text = value
    }
    
}
