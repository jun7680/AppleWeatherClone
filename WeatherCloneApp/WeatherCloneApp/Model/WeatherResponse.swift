//
//  WeatherResponse.swift
//  WeatherCloneApp
//
//  Created by 옥인준 on 2023/02/21.
//

import Foundation

struct WeatherResponse: Codable {
    let list: [WeatherList]
}

struct WeatherList: Codable {

    let dt: Double
    let main: Main
    let weather: [Weather]
    let clouds: Clouds
    let wind: Wind
    let visibility: Int
    let rain: Rain?
    let dtTxt: String
    
    enum CodingKeys: String, CodingKey {
        case dt
        case main
        case weather
        case clouds
        case wind
        case visibility
        case rain
        case dtTxt = "dt_txt"
    }
}

struct Main: Codable {
    let temp: Double
    let feelsLike: Double
    let tempMin: Double
    let tempMax: Double
    let pressure: Int
    let seaLevel: Int
    let grndLevel: Int
    let humidity: Int
    let tempKf: Double
    
    enum CodingKeys: String, CodingKey {
        case temp, pressure, humidity
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
        case tempKf = "temp_kf"
    }
}

struct Weather: Codable {
    let id: Int
    let main: WeatherStatus
    let description: String
    let icon: String
}

struct Clouds: Codable {
    let all: Int
}

struct Wind: Codable {
    let speed: Double
    let deg: Int
    let gust: Double
}

struct Rain: Codable {
    let threeHours: Double
    
    enum CodingKeys: String, CodingKey {
        case threeHours = "3h"
    }
}

extension WeatherList {
    var dtToDate: String {
        return dt.convertingUTCtime.dtToDate
    }
    
    var dayOfWeek: String {
        return dt.convertingUTCtime.dayOfWeek
    }
}


enum WeatherStatus: String, Codable {
    case clouds = "Clouds"
    case snow = "Snow"
    case rain = "Rain"
    case sunny = "Clear"
    
    var icon: String {
        switch self {
        case .clouds: return "clouds"
        case .snow: return "fog"
        case .rain: return "rain"
        case .sunny: return "sunny"
        }
    }
}
