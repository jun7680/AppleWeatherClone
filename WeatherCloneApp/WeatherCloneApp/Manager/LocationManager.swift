//
//  LocationManager.swift
//  WeatherCloneApp
//
//  Created by 옥인준 on 2023/02/21.
//

import Foundation
import CoreLocation

/// Location Manager
class LocationManager {
    static func reverseParsing(lat: Double, lon: Double, completion: @escaping (String) -> Void) {
        let location = CLLocation(latitude: lat, longitude: lon)
        let geocoder = CLGeocoder()
        let locale = Locale(identifier: "Ko-kr")

        geocoder.reverseGeocodeLocation(
            location,
            preferredLocale: locale
        ) { place, error in
            if let place, let local = place[0].locality {
                completion(local)
            } else {
                completion(place?[0].country ?? "")
            }
        }
    }
}
