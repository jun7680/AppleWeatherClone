//
//  CityListResponse.swift
//  WeatherCloneApp
//
//  Created by 옥인준 on 2023/02/22.
//

import Foundation

struct CityListResponse: Codable {
    let id: Int
    let name: String
    let country: String
    let coord: Coordinate
}

struct Coordinate: Codable {
    let lat: Double
    let lon: Double
}
