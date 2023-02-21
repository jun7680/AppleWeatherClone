//
//  MainViewModel.swift
//  WeatherCloneApp
//
//  Created by 옥인준 on 2023/02/21.
//

import Foundation
import CoreLocation

class MainViewModel {

    func test(lat: Double, lon: Double) {
        let location = CLLocation(latitude: lat, longitude: lon)
        let geocoder = CLGeocoder()
        let locale = Locale(identifier: "Ko-kr")
        
        geocoder.reverseGeocodeLocation(location, preferredLocale: locale) { placemark, error in
            guard let placemark else { return }
            let location = placemark.first?.locality
            
        }
    }
}
