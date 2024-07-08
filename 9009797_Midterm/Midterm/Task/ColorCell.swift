//
//  ColorCell.swift
//  Midterm
//
//  Created by Adeesh on 2024-06-28.
//

import UIKit

class ColorCell: UICollectionViewCell {

    @IBOutlet weak var viewColor: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configureCell(value: TaskColor) {
        self.viewColor.layer.cornerRadius = self.viewColor.frame.width / 2
        self.viewColor.hexStringToUIColor(hex: value.color ?? "")
        if value.isSeleted == true {
            self.viewColor.layer.borderWidth = 2
            self.viewColor.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        } else {
            self.viewColor.layer.borderWidth = 0
        }
    }
}
