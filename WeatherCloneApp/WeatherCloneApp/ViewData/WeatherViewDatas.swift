//
//  HeaderViewData.swift
//  WeatherCloneApp
//
//  Created by 옥인준 on 2023/02/21.
//

import Foundation

struct HeaderViewData {
    let city: String
    let temp: Double
    let minTemp: Double
    let maxTemp: Double
    let weatherSatus: String
}

struct HourlyViewData {
    let city: String
    let date: String
    let icon: String
    let temp: Double
    let minTemp: Double
    let maxTemp: Double
    let weatherSatus: String
    let humidity: Int
    let clouds: Int
    let wind: Double
    let weather: WeatherStatus
}

struct WeekendViewData {
    let weekend: String
    let icon: String
    var temp: (min: Double, max: Double)
}

struct DetailViewData {
//    let humidity: Int
//    let clouds: Int
//    let wind: Double
}

enum DetailDataType {
    case humidity(value: Int)
    case clouds(value: Int)
    case wind(value: Double)
    
    var value: (title: String, value: String) {
        switch self {
        case let .humidity(value): return ("습도", "\(value)%")
        case let .clouds(value): return ("구름", "\(value)%")
        case let .wind(value): return ("바람", "\(value)m/s")
        }
    }
}
