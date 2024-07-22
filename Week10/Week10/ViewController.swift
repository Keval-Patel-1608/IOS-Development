import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var locationDisplay: UILabel!
    @IBOutlet weak var weatherDisplay: UILabel!
    @IBOutlet weak var weatherIconDisplay: UIImageView!
    @IBOutlet weak var temperatureDisplay: UILabel!
    @IBOutlet weak var humidityDisplay: UILabel!
    @IBOutlet weak var windDisplay: UILabel!

    let locationManager = CLLocationManager()
       
       override func viewDidLoad() {
           super.viewDidLoad()
           
           locationManager.delegate = self
           locationManager.requestWhenInUseAuthorization()
           locationManager.startUpdatingLocation()
           
           // Additional logging
           print("viewDidLoad: Location Manager started.")
       }
       
       func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
           if let location = locations.last {
               let lat = location.coordinate.latitude
               let lon = location.coordinate.longitude
               print("Location updated: lat: \(lat), lon: \(lon)")
               fetchWeather(latitude: lat, longitude: lon)
           }
       }

    // MARK: - Networking
    func fetchWeather(latitude: Double, longitude: Double) {
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
                DispatchQueue.main.async {
                    self.updateUI(with: weather)
                }
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
            fetchWeatherIcon(for: icon)
        }
    }

    func fetchWeatherIcon(for icon: String) {
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
                self.weatherIconDisplay.image = UIImage(data: data)
            }
        }
        dataTask.resume()
    }
}
