//
//  FriendsTBLCell.swift
//  Lab6_Tableview
//
//  Created by user244 on 2024-07-06.
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
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
        
    func configureCell(value: Friend) {
        self.viewBg.layer.cornerRadius = 10
        self.viewBg.backgroundColor =  UIColor(red: 225/255, green: 216/255, blue: 225/255, alpha: 1)
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
