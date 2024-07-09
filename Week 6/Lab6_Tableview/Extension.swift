//
//  Extension.swift
//  Lab6_Tableview
//
//  Created by Adeesh on 2024-07-07.
//

import UIKit


extension UIColor {
    static func random() -> UIColor {
        return UIColor(
           red:   .random(),
           green: .random(),
           blue:  .random(),
           alpha: 0.1
        )
    }
}

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension UIView {
    func addDropShadow(shadowColor: CGColor? = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).cgColor, shadowOpacity: Float = 0.3,
                       shadowOffset: CGSize = CGSize(width: 0, height: -2),
                       shadowRadius: CGFloat = 10) {
        
        self.layer.shadowColor = shadowColor
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowOffset = shadowOffset
        self.layer.shadowRadius = shadowRadius
        self.layer.masksToBounds = false
    }
}

extension UIViewController {
    func showSimpleAlert(title:String? = nil,
                         actionTitle:String? = "OK",
                         alertStyle: UIAlertController.Style = .alert,
                         actionHandler: (() -> Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: "", preferredStyle: alertStyle)
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: { (action:UIAlertAction) in
            actionHandler?()
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
