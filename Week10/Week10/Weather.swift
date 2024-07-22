import Foundation

// MARK: - Weather
struct Weather: Codable {
    let coord: Coord
    let weather: [WeatherElement]
    let base: String
    let main: Main
    let visibility: Int
    let wind: Wind
    let clouds: Clouds
    let dt: Int
    let sys: Sys
    let timezone, id: Int
    let name: String
    let cod: Int
}

// MARK: - Clouds
struct Clouds: Codable {
    let all: Int
}

// MARK: - Coord
struct Coord: Codable {
    let lon, lat: Double
}

// MARK: - Main
struct Main: Codable {
    let temp, feelsLike, tempMin, tempMax: Double
    let pressure, humidity, seaLevel, grndLevel: Int

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure, humidity
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
    }
}

// MARK: - Sys
struct Sys: Codable {
    let type, id: Int
    let country: String
    let sunrise, sunset: Int
}

// MARK: - WeatherElement
struct WeatherElement: Codable {
    let id: Int
    let main, description, icon: String
}

// MARK: - Wind
struct Wind: Codable {
    let speed: Double
    let deg: Int
    let gust: Double
}

//API Session
    let urlString = "https://api.openweathermap.org/data/2.5/weather?q=Waterloo,CA&appid=0396aac6351c1459c974171411e1a72e"

    let urlSession = URLSession(configuration: .default)
    let url = URL(string: urlString)

if let url = url {
    let dataTask = urlSession.dataTask(with: url) { (data, response, error) in
        
        if let data = data {
            print(data)
            let jsonDecoder = JSONDecoder()
            do {
                let readableData = try jsonDecoder.decode(Weather.self, from: data)
                print (readableData)
                print (readableData)
                print (readableData)
                print (readableData)
                print (readableData)
                print (readableData)
            }
            catch {
                print ("Can't Decode Data")
            }
        }
    }
    dataTask.resume()
    dataTask.response
}
