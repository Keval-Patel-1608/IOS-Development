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
        self.viewBg.backgroundColor =  UIColor(red: 209/255, green: 204/255, blue: 255/255, alpha: 1)
        self.lblName.text = value.name
        self.lblEmail.text = value.email
        self.lblPhone.text = value.phone
        
        self.imgOne.layer.cornerRadius = 10
        self.imgTwo.layer.cornerRadius = 10
        self.imgThree.layer.cornerRadius = 10
        
        self.imgOne.image = value.images[0]
        self.imgTwo.image = value.images[1]
        self.imgThree.image = value.images[2]
        
    }
}
