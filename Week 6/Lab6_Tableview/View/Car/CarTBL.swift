//
//  CarTBL.swift
//  Lab6_Tableview
//
//  Created by user244 on 2024-07-06.
//

import UIKit

class CarTBL: UITableViewCell {

    @IBOutlet weak var viewBG: UIView!
    @IBOutlet weak var imgCar: UIImageView!
    @IBOutlet weak var lblCarMake: UILabel!
    @IBOutlet weak var lblCarModel: UILabel!
    
    static let identifier = String(describing: CarTBL.self)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.viewBG.addDropShadow(shadowColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.4).cgColor)
        self.imgCar.layer.cornerRadius = 5
        self.imgCar.layer.borderWidth = 2
        self.imgCar.layer.borderColor = UIColor(red: 204/255, green: 153/255, blue: 255/255, alpha: 1).cgColor
        self.viewBG.backgroundColor = UIColor(red: 209/255, green: 204/255, blue: 255/255, alpha: 1)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(value: Car) {
        self.imgCar.image = value.image
        self.lblCarMake.text = value.make
        self.lblCarModel.text = value.model
    }
    
}
