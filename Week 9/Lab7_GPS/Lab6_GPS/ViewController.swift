//
//  ViewController.swift
//  Lab6_GPS
//
//  Created by user228293 on 7/11/24.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate{

    @IBOutlet weak var tripStatus: UIView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var speedExceedIndicator: UIView!
    @IBOutlet weak var maxAccelerateDisplay: UILabel!
    @IBOutlet weak var distCoveredDisplay: UILabel!
    @IBOutlet weak var avgSpeedDisplay: UILabel!
    @IBOutlet weak var maxSpeedDisplay: UILabel!
    @IBOutlet weak var currentSpeedDisplay: UILabel!
    @IBOutlet weak var distBeforeOverspeed: UILabel!
    
    let locationDetector = CLLocationManager()
    var maxSpd: CLLocationSpeed = 0
    var totalSpd: CLLocationSpeed = 0
    var spdCount: Int = 0
    var totalDist: CLLocationDistance = 0
    var lastLoc: CLLocation?
    var maxAcceleration: Double = 0
    
    @IBAction func StartTripButton(_ sender: Any) {
        locationDetector.startUpdatingLocation()
        tripStatus.backgroundColor = .green
        resetTripData()
    }
    
    @IBAction func StopTripButton(_ sender: Any) {
        locationDetector.stopUpdatingLocation()
        tripStatus.backgroundColor = .gray
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationDetector.delegate = self
        locationDetector.requestWhenInUseAuthorization()
        mapView.showsUserLocation = true
    }
    
    func resetTripData() {
        maxSpd = 0
           totalSpd = 0
           spdCount = 0
           totalDist = 0
           lastLoc = nil
           maxAcceleration = 0
           
        currentSpeedDisplay.text = "0 km/h"
        maxSpeedDisplay.text = "0 km/h"
        avgSpeedDisplay.text = "0 km/h"
        distCoveredDisplay.text = "0 km"
        maxAccelerateDisplay.text = "0 m/s^2"
        speedExceedIndicator.backgroundColor = .clear
       }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
               
            let speed = max(location.speed, 0) // to check if speed is non-negative
            currentSpeedDisplay.text = String(format: "%.2f km/h", speed * 3.6) // Convert m/s to km/h
               
               if speed > maxSpd {
                   maxSpd = speed
                   maxSpeedDisplay.text = String(format: "%.2f km/h", maxSpd * 3.6)
               }
               
               totalSpd += speed
               spdCount += 1
               let averageSpeed = totalSpd / Double(spdCount)
               avgSpeedDisplay.text = String(format: "%.2f km/h", averageSpeed * 3.6)
               
               if let lastLocation = lastLoc {
                   let distance = location.distance(from: lastLocation)
                   totalDist += distance
                   distCoveredDisplay.text = String(format: "%.2f km", totalDist / 1000) // Convert m into km
                   
                   let acceleration = abs(speed - lastLocation.speed) / location.timestamp.timeIntervalSince(lastLocation.timestamp)
                   if acceleration > maxAcceleration {
                       maxAcceleration = acceleration
                       maxAccelerateDisplay.text = String(format: "%.2f m/s^2", maxAcceleration)
                   }
               }
               
               lastLoc = location
               
               // Change the speed indicator color if speed exceeds 115 km/h
               if speed * 3.6 > 115 {
                   speedExceedIndicator.backgroundColor = .red
               } else {
                   speedExceedIndicator.backgroundColor = .clear
               }
               
            let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
               mapView.setRegion(region, animated: true)
           }
}

