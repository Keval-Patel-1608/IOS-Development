//
//  Extension+UIViewController.swift
//  Assignment2
//
//  Created by Keval on 2024-06-21.
//

import UIKit

extension UIViewController {
    func showAlertWithInputDialog(title:String? = nil,
                                  subtitle:String? = nil,
                                  actionTitle:String? = "Ok",
                                  cancelTitle:String? = "Cancel",
                                  cancelHandler: ((UIAlertAction) -> Void)? = nil,
                                  actionHandler: ((LaptopModel?, Bool) -> Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: subtitle, preferredStyle: .alert)
        alert.addTextField { (textField:UITextField) in
            textField.placeholder = "Laptop Name"
            textField.keyboardType = UIKeyboardType.default
        }
        alert.addTextField { (textField:UITextField) in
            textField.placeholder = "Laptop Details"
            textField.keyboardType = UIKeyboardType.default
        }
        
        alert.addTextField { (textField:UITextField) in
            textField.placeholder = "Price"
            textField.keyboardType = UIKeyboardType.decimalPad
        }
        
        alert.addAction(UIAlertAction(title: cancelTitle, style: .destructive, handler: cancelHandler))
        
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: { (action:UIAlertAction) in
            guard alert.textFields?[0].text != "" && alert.textFields?[1].text != "" || alert.textFields?[2].text != "" else {
                actionHandler?(nil, false)
                return
            }

            let objLaptop = LaptopModel(title: alert.textFields?[0].text ?? "", details: alert.textFields?[1].text ?? "", price: Double(alert.textFields?[2].text ?? "0.00"), isStatic: false)
            actionHandler?(objLaptop, true)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func showSimpleAlert(title:String? = nil,
                         actionTitle:String? = "Add",
                         alertStyle: UIAlertController.Style = .alert,
                         actionHandler: (() -> Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: "", preferredStyle: alertStyle)
        alert.addAction(UIAlertAction(title: actionTitle, style: .destructive, handler: { (action:UIAlertAction) in
            actionHandler?()
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

extension UIView {
    func addDropShadow(shadowColor: UIColor = #colorLiteral(red: 0.5723067522, green: 0.5723067522, blue: 0.5723067522, alpha: 1),
                       shadowOpacity: Float = 0.5,
                       shadowOffset: CGSize = CGSize(width: 0, height: 2),
                       shadowRadius: CGFloat = 4) {
        
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowOffset = shadowOffset
        self.layer.shadowRadius = shadowRadius
        self.layer.masksToBounds = false
    }
}
