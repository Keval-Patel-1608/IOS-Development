//
//  CustomTabBarController.swift
//  Midterm
//
//  Created by Adeesh on 2024-07-05.
//

import UIKit

class CustomTabBarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if let vc = viewController as? TaskListVC {
            vc.selectedValues.removeAll()
            vc.isNeedToCall = true
        }
        
    }

}
