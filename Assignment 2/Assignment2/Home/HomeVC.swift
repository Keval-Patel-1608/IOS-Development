//
//  ViewController.swift
//  Assignment2
//
//  Created by Keval on 2024-06-21.
//

import UIKit

class HomeVC: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var btnMoniter: UIButton!
    @IBOutlet weak var btnLaptop: UIButton!
    
    
    //MARK: - Viiew Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = ""
        self.buttonConfiguration()
    }

    private func buttonConfiguration() {
        self.btnMoniter.layer.cornerRadius = 20
        self.btnLaptop.layer.cornerRadius = 20
    }
}

//MARK: - Button Action
extension HomeVC {
    @IBAction func btnOptions(_ sender: UIButton) {
        if sender.tag == 1 {
            self.showSimpleAlert(title: "No monitor yet. Check back later!", actionTitle: "Ok") {
                self.dismiss(animated: true)
            }
        } else {
            let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
            let laptopVC = storyBoard.instantiateViewController(withIdentifier: "LaptopVC")
            self.navigationController?.pushViewController(laptopVC, animated: true)
        }
    }
}

