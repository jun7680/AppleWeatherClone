//
//  WeatherInfoType.swift
//  WeatherCloneApp
//
//  Created by 옥인준 on 2023/02/21.
//

import Foundation

enum WeatherInfoType: Int {
    static let numberOfSection = 4
    
    case hourly
    case weekend
    case location
    case detail
    
    init?(index: Int) {
        guard let type = WeatherInfoType(rawValue: index) else { return nil }
        
        self = type
    }
    
}
