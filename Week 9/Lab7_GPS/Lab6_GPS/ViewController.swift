//
//  ViewController.swift
//  Lab6_GPS
//
//  Created by user244717 on 7/11/24.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {

    // Outlets for UI elements
    @IBOutlet weak var tripStatus: UIView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var speedExceedIndicator: UIView!
    @IBOutlet weak var maxAccelerateDisplay: UILabel!
    @IBOutlet weak var distCoveredDisplay: UILabel!
    @IBOutlet weak var avgSpeedDisplay: UILabel!
    @IBOutlet weak var maxSpeedDisplay: UILabel!
    @IBOutlet weak var currentSpeedDisplay: UILabel!
    @IBOutlet weak var predictedDistBeforeOverspeed: UILabel!

    // Core Location manager
    let locationManager = CLLocationManager()
    
    // Variables to keep track of speed and distance
    var maxSpeed: CLLocationSpeed = 0
    var totalSpeed: CLLocationSpeed = 0
    var speedCount: Int = 0
    var totalDistance: CLLocationDistance = 0
    var lastLocation: CLLocation?
    var maxAcceleration: Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setting up the location manager
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        mapView.showsUserLocation = true
    }
    
    // Action to start trip
    @IBAction func startTripButtonTapped(_ sender: Any) {
        locationManager.startUpdatingLocation()
        tripStatus.backgroundColor = .green
        resetTripData()
    }

    // Action to stop trip
    @IBAction func stopTripButtonTapped(_ sender: Any) {
        locationManager.stopUpdatingLocation()
        tripStatus.backgroundColor = .gray
    }

    // Function to reset trip data
    func resetTripData() {
        maxSpeed = 0
        totalSpeed = 0
        speedCount = 0
        totalDistance = 0
        lastLocation = nil
        maxAcceleration = 0

        currentSpeedDisplay.text = "0 km/h"
        maxSpeedDisplay.text = "0 km/h"
        avgSpeedDisplay.text = "0 km/h"
        distCoveredDisplay.text = "0 km"
        maxAccelerateDisplay.text = "0 m/s^2"
        predictedDistBeforeOverspeed.text = "0 km"
        speedExceedIndicator.backgroundColor = .clear
    }

    // CLLocationManagerDelegate method to update locations
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }

        // Update current speed
        let speed = max(location.speed, 0) // Ensure speed is non-negative
        currentSpeedDisplay.text = String(format: "%.2f km/h", speed * 3.6) // Convert m/s to km/h

        // Update maximum speed
        if speed > maxSpeed {
            maxSpeed = speed
            maxSpeedDisplay.text = String(format: "%.2f km/h", maxSpeed * 3.6)
        }

        // Update average speed
        totalSpeed += speed
        speedCount += 1
        let averageSpeed = totalSpeed / Double(speedCount)
        avgSpeedDisplay.text = String(format: "%.2f km/h", averageSpeed * 3.6)

        // Update distance and acceleration
        if let lastLocation = lastLocation {
            let distance = location.distance(from: lastLocation)
            totalDistance += distance
            distCoveredDisplay.text = String(format: "%.2f km", totalDistance / 1000) // Convert m to km

            // Calculate acceleration
            // acceleration = |v - v0| / Δt
            let acceleration = abs(speed - lastLocation.speed) / location.timestamp.timeIntervalSince(lastLocation.timestamp)
            if acceleration > maxAcceleration {
                maxAcceleration = acceleration
                maxAccelerateDisplay.text = String(format: "%.2f m/s^2", maxAcceleration)
            }

            // Predict the distance before overspeeding
            // distance = v0 * t + 0.5 * a * t^2
            if speed * 3.6 < 115 && acceleration > 0 {
                let targetSpeed = 115.0 / 3.6 // Convert 115 km/h to m/s
                // time to reach target speed = (v_f - v0) / a
                let timeToReachTargetSpeed = (targetSpeed - speed) / acceleration
                // predicted distance = v0 * t + 0.5 * a * t^2
                let predictedDistance = speed * timeToReachTargetSpeed + 0.5 * acceleration * pow(timeToReachTargetSpeed, 2)
                predictedDistBeforeOverspeed.text = String(format: "%.2f km", predictedDistance / 1000) // Convert m to km
            } else {
                predictedDistBeforeOverspeed.text = "0 km"
            }
        } else if speed * 3.6 < 115 {
            // Predict distance at the start of the trip
            let targetSpeed = 115.0 / 3.6 // Convert 115 km/h to m/s
            // time to reach target speed = v_f / a
            let timeToReachTargetSpeed = targetSpeed / maxAcceleration
            // predicted distance = 0.5 * a * t^2
            let predictedDistance = 0.5 * maxAcceleration * pow(timeToReachTargetSpeed, 2)
            predictedDistBeforeOverspeed.text = String(format: "%.2f km", predictedDistance / 1000) // Convert m to km
        }

        lastLocation = location

        // Update the speed exceed indicator
        if speed * 3.6 > 115 {
            speedExceedIndicator.backgroundColor = .red
            predictedDistBeforeOverspeed.text = "0 km"
        } else {
            speedExceedIndicator.backgroundColor = .clear
        }

        // Update the map view region
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true)
    }
}
