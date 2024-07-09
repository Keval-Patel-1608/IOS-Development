//
//  ColorCell.swift
//  Midterm
//
//  Created by Admin on 2024-06-28.
//

import UIKit

class ColorCell: UICollectionViewCell {

    @IBOutlet weak var viewColor: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configureCell(value: TaskColor) {
        // Setting the corner radius to make the view circular
        self.viewColor.layer.cornerRadius = self.viewColor.frame.width / 2
        // Converting the hex string to UIColor and setting it to the view's background color
        self.viewColor.hexStringToUIColor(hex: value.color ?? "")
        // Adding a border if the color is selected, removing it otherwise
        if value.isSeleted == true {
            self.viewColor.layer.borderWidth = 2
            self.viewColor.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        } else {
            self.viewColor.layer.borderWidth = 0
        }
    }
}
