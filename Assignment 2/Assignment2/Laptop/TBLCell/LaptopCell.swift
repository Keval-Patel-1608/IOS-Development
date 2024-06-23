//
//  LaptopCell.swift
//  Assignment2
//
//  Created by Keval on 2024-06-21.
//

import UIKit

class LaptopCell: UITableViewCell {

    @IBOutlet weak var viewBG: UIView!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDetails: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func confgiureCell(object: LaptopModel) {
        self.viewBG.addDropShadow()
        self.lblTitle.text = object.title ?? ""
        self.lblDetails.text = object.details ?? ""
        self.lblPrice.text =  "$" + String(format:"%.02f", object.price ?? 0.00)
    }
}
