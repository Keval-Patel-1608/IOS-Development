//
//  FriendsTBLCell.swift
//  Lab6_Tableview
//
//  Created by Adeesh on 2024-07-07.
//

import UIKit

class FriendsTBLCell: UITableViewCell {

    @IBOutlet weak var viewBg: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var imgOne: UIImageView!
    @IBOutlet weak var imgTwo: UIImageView!
    @IBOutlet weak var imgThree: UIImageView!
    
    static let identifier = String(describing: FriendsTBLCell.self)
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
        
    func configureCell(value: Friend) {
        self.viewBg.layer.cornerRadius = 10
        self.viewBg.backgroundColor = .random()
        self.lblName.text = value.name
        self.lblEmail.text = value.email
        self.lblPhone.text = value.phone
        
        
        self.imgOne.layer.cornerRadius = self.imgOne.frame.width / 2
        self.imgOne.layer.borderWidth = 2
        self.imgOne.layer.borderColor = #colorLiteral(red: 0.9348526597, green: 0.9697601199, blue: 0.9562346339, alpha: 1).cgColor
        
        self.imgTwo.layer.cornerRadius = self.imgOne.frame.width / 2
        self.imgTwo.layer.borderWidth = 2
        self.imgTwo.layer.borderColor = #colorLiteral(red: 0.9348526597, green: 0.9697601199, blue: 0.9562346339, alpha: 1).cgColor
        
        self.imgThree.layer.cornerRadius = self.imgOne.frame.width / 2
        self.imgThree.layer.borderWidth = 2
        self.imgThree.layer.borderColor = #colorLiteral(red: 0.9348526597, green: 0.9697601199, blue: 0.9562346339, alpha: 1).cgColor
        
        self.imgOne.image = value.images[0]
        self.imgTwo.image = value.images[1]
        self.imgThree.image = value.images[2]
        
    }
}
