//
//  Extension.swift
//  Midterm
//
//  Created by Adeesh on 2024-06-28.
//

import UIKit

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
    
    func addDashedBorder() {
        let color = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1).cgColor
        
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        let frameSize = self.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
        
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color
        shapeLayer.lineWidth = 2
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPattern = [6,3]
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 5).cgPath
        
        self.layer.addSublayer(shapeLayer)
    }
    
    func hexStringToUIColor(hex:String) {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            self.backgroundColor = UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        self.backgroundColor = UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    func cornerRadiusWithPath(corner: UIRectCorner = [.topLeft, .bottomLeft]) {
        let pathWithRadius = UIBezierPath(roundedRect:self.bounds, byRoundingCorners: corner, cornerRadii: CGSizeMake(10.0, 10.0))
        let maskLayer = CAShapeLayer()
        maskLayer.path = pathWithRadius.cgPath
        self.layer.mask = maskLayer
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
    
    func showSimpleAlertWithCancelOption(title:String? = nil,
                         actionTitle:String? = "OK",
                         actionTitleCancel:String? = "Cancel",
                         alertStyle: UIAlertController.Style = .alert,
                         actionHandler: ((Bool) -> Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: "", preferredStyle: alertStyle)
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: { (action:UIAlertAction) in
            actionHandler?(false)
        }))
        
        alert.addAction(UIAlertAction(title: actionTitleCancel, style: .destructive, handler: { (action:UIAlertAction) in
            actionHandler?(true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

extension UITextField {
    
    func addInputViewDatePicker(target: Any, selector: Selector) {
        
        let screenWidth = UIScreen.main.bounds.width
        
        //Add DatePicker as inputView
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))
        datePicker.datePickerMode = .date
        datePicker.minimumDate = Date()
        datePicker.preferredDatePickerStyle = .wheels
        self.inputView = datePicker
        
        //Add Tool Bar as input AccessoryView
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 44))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelBarButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPressed))
        let doneBarButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector)
        toolBar.setItems([cancelBarButton, flexibleSpace, doneBarButton], animated: false)
        
        self.inputAccessoryView = toolBar
    }
    
    @objc func cancelPressed() {
        self.resignFirstResponder()
    }
}
