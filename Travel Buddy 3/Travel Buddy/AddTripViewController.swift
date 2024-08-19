//
//  AddTripViewController.swift
//  Travel Buddy
//
//  Created by Admin on 2024-08-17.
//
import UIKit
import CoreData

class AddTripViewController: UIViewController {
    
    @IBOutlet weak var tripNameTextField: UITextField!
    @IBOutlet weak var destinationTextField: UITextField!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    @IBOutlet weak var startingLocationTextField: UITextField! // New Outlet
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        saveTripData()
    }
    
    func saveTripData() {
        guard let tripName = tripNameTextField.text, !tripName.isEmpty,
              let destination = destinationTextField.text, !destination.isEmpty,
              let startingLocation = startingLocationTextField.text, !startingLocation.isEmpty else {
            showAlert(message: "Please fill in all fields.")
            return
        }
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let newTrip = Trip(context: context)
        newTrip.name = tripName
        newTrip.destination = destination
        newTrip.startingLocation = startingLocation // Save Starting Location
        newTrip.startDate = startDatePicker.date
        newTrip.endDate = endDatePicker.date
        
        do {
            try context.save()
            showAlert(message: "Trip saved successfully.")
        } catch {
            print("Error saving trip: \(error)")
        }
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
