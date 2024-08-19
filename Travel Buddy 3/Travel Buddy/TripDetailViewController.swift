import UIKit
import MapKit
import CoreLocation

class TripDetailViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    // Outlets for UI elements
    @IBOutlet weak var locationDisplay: UILabel!
    @IBOutlet weak var weatherDisplay: UILabel!
    @IBOutlet weak var weatherIconDisplay: UIImageView!
    @IBOutlet weak var temperatureDisplay: UILabel!
    @IBOutlet weak var humidityDisplay: UILabel!
    @IBOutlet weak var windDisplay: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var zoomSlider: UISlider!
    @IBOutlet weak var carImageView: UIImageView!
    @IBOutlet weak var walkImageView: UIImageView!

    // Properties to manage location, weather, and routing
    var locationManager: CLLocationManager!
    var startLocation: CLLocationCoordinate2D?
    var endLocation: CLLocationCoordinate2D?
    var selectedTransportType: MKDirectionsTransportType = .automobile
    var trip: Trip? // Assuming Trip model is available

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up map view
        mapView.delegate = self

        // Initialize and configure location manager
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()

        // Set up zoom slider
        zoomSlider.minimumValue = 0.02
        zoomSlider.maximumValue = 0.2
        zoomSlider.value = 0.1
        zoomSlider.addTarget(self, action: #selector(zoomMap), for: .valueChanged)

        // Add tap gestures to image views for transport selection
        addTapGesture(to: carImageView, action: #selector(selectCar))
        addTapGesture(to: walkImageView, action: #selector(selectWalk))

        // Set initial transport type
        selectCar()

        // Convert addresses to coordinates and show route
        if let trip = trip {
            geocodeAddress(trip.startingLocation ?? "Waterloo") { [weak self] coordinate in
                self?.startLocation = coordinate
                if let endLocation = self?.endLocation {
                    self?.showRoute()
                }
            }

            geocodeAddress(trip.destination ?? "Kitchner") { [weak self] coordinate in
                self?.endLocation = coordinate
                if let startLocation = self?.startLocation {
                    self?.showRoute()
                }
            }
        }
    }

    // CLLocationManagerDelegate method for location updates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }

        // Update the map to center around user's location
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        mapView.setRegion(region, animated: true)

        // Add a pin for the user's location
        let userAnnotation = MKPointAnnotation()
        userAnnotation.coordinate = location.coordinate
        userAnnotation.title = "You are here"
        mapView.addAnnotation(userAnnotation)

        // Fetch weather data for current location
        fetchWeather()
    }

    func showAlertWithMessage(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    // CLLocationManagerDelegate method for authorization status changes
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        case .restricted, .denied:
            showAlertWithMessage("Location services are not authorized. Please enable them in Settings.")
        @unknown default:
            break
        }
    }

    // MARK: - Networking for Weather
    func fetchWeather() {
        let apiKey = "0396aac6351c1459c974171411e1a72e"
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(trip?.destination ?? ""),CA&appid=\(apiKey)&units=metric"

        guard let url = URL(string: urlString) else { return }

        let urlSession = URLSession(configuration: .default)
        let dataTask = urlSession.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error fetching weather data: \(error)")
                return
            }

            guard let data = data else { return }

            do {
                let jsonDecoder = JSONDecoder()
                let weather = try jsonDecoder.decode(Weather.self, from: data)
                DispatchQueue.main.async {
                    self.updateUI(with: weather)
                }
            } catch {
                print("Failed to decode weather data: \(error)")
            }
        }
        dataTask.resume()
    }

    func fetchDestinationWeather(latitude: Double, longitude: Double) {
        let apiKey = "0396aac6351c1459c974171411e1a72e"
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)&units=metric"

        guard let url = URL(string: urlString) else { return }

        let urlSession = URLSession(configuration: .default)
        let dataTask = urlSession.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error fetching weather data: \(error)")
                return
            }

            guard let data = data else { return }

            do {
                let jsonDecoder = JSONDecoder()
                let weather = try jsonDecoder.decode(Weather.self, from: data)
//                DispatchQueue.main.async {
//                    self.updateDestinationWeatherUI(with: weather)
//                }
            } catch {
                print("Failed to decode weather data: \(error)")
            }
        }
        dataTask.resume()
    }

    // MARK: - UI Update
    func updateUI(with weather: Weather) {
        locationDisplay.text = weather.name
        weatherDisplay.text = weather.weather.first?.description
        temperatureDisplay.text = "\(Int(weather.main.temp))°C"
        humidityDisplay.text = "\(weather.main.humidity)%"
        
        let windSpeedKmH = Int(weather.wind.speed * 3.6)
        windDisplay.text = "\(windSpeedKmH) km/h"
        
        if let icon = weather.weather.first?.icon {
            fetchWeatherIcon(for: icon, imageView: weatherIconDisplay)
        }
    }

    func fetchWeatherIcon(for icon: String, imageView: UIImageView) {
        let urlString = "https://openweathermap.org/img/wn/\(icon)@2x.png"
        guard let url = URL(string: urlString) else { return }

        let urlSession = URLSession(configuration: .default)
        let dataTask = urlSession.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error fetching weather icon: \(error)")
                return
            }

            guard let data = data else { return }

            DispatchQueue.main.async {
                imageView.image = UIImage(data: data)
            }
        }
        dataTask.resume()
    }

    // MARK: - Routing
    func showRoute() {
        guard let startLocation = startLocation, let endLocation = endLocation else { return }

        let startPlacemark = MKPlacemark(coordinate: startLocation)
        let endPlacemark = MKPlacemark(coordinate: endLocation)

        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: startPlacemark)
        request.destination = MKMapItem(placemark: endPlacemark)
        request.transportType = selectedTransportType

        let directions = MKDirections(request: request)
        directions.calculate { response, error in
            guard let response = response else {
                if let error = error {
                    print("Error calculating directions: \(error)")
                }
                return
            }

            // Show the route on the map
            self.mapView.removeOverlays(self.mapView.overlays)
            if let route = response.routes.first {
                self.mapView.addOverlay(route.polyline)
            }
        }
    }

    // Delegate method to render route on map
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 5.0
        return renderer
    }

    // MARK: - Transport selection methods
    @objc func selectCar() {
        selectedTransportType = .automobile
        selectTransportImageView(carImageView)
    }

    @objc func selectWalk() {
        selectedTransportType = .walking
        selectTransportImageView(walkImageView)
    }

    // Helper method to visually select a transport option
    func selectTransportImageView(_ selectedImageView: UIImageView) {
        let imageViews = [carImageView, walkImageView]
        imageViews.forEach { imageView in
            imageView?.alpha = (imageView == selectedImageView) ? 1.0 : 0.5
        }
        showRoute()
    }

    @objc func handleNavigationTap() {
        // Action when navigation view is tapped
    }

    // MARK: - Zooming the map
    @objc func zoomMap() {
        let zoomLevel = zoomSlider.value
        var region = mapView.region
        region.span.latitudeDelta = CLLocationDegrees(zoomLevel)
        region.span.longitudeDelta = CLLocationDegrees(zoomLevel)
        mapView.setRegion(region, animated: true)
    }

    // MARK: - Geocoding addresses to coordinates
    func geocodeAddress(_ address: String, completion: @escaping (CLLocationCoordinate2D?) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { placemarks, error in
            if let error = error {
                print("Geocoding error: \(error)")
                completion(nil)
                return
            }

            if let coordinate = placemarks?.first?.location?.coordinate {
                completion(coordinate)
            } else {
                completion(nil)
            }
        }
    }

    // MARK: - Utility method to add tap gesture to image views
    func addTapGesture(to imageView: UIImageView, action: Selector) {
        let tapGesture = UITapGestureRecognizer(target: self, action: action)
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGesture)
    }
}
