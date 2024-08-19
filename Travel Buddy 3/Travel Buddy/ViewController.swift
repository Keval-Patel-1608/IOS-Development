//
//  ViewController.swift
//  Travel Buddy
//
//  Created by Admin on 8/11/24.
//
import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func addTripButtonPressed(_ sender: UIButton) {
        // Perform segue to Add Trip page
        performSegue(withIdentifier: "AddTrip", sender: self)
    }
}
