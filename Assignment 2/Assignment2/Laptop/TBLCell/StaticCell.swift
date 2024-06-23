//
//  StaticCell.swift
//  Assignment2
//
//  Created by Keval on 2024-06-21.
//

import UIKit

class StaticCell: UITableViewCell {

    @IBOutlet weak var viewBG: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.viewBG.addDropShadow()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
