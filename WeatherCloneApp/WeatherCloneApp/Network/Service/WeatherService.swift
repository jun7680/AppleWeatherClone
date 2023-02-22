//
//  WeatherService.swift
//  WeatherCloneApp
//
//  Created by 옥인준 on 2023/02/21.
//

import Foundation
import RxSwift
import Alamofire

protocol WeatherServiceType {
    static func fetch(lat: Double, lon: Double) -> Single<WeatherResponse>
    static func readCityList() -> Single<[CityListResponse]>
}

class WeatherService: WeatherServiceType {
    
    static func fetch(lat: Double, lon: Double) -> Single<WeatherResponse> {
        let type = WeatherAPI.fetch(lat: lat, lon: lon)
    
        return SessionManager.request(WeatherResponse.self, apiType: type)
    }
    
    static func readCityList() -> Single<[CityListResponse]> {
        Single<[CityListResponse]>.create { single in
            let data = Bundle.main.citiList
            
            do {
                let model = try JSONDecoder().decode([CityListResponse].self, from: data)
                single(.success(model))
            } catch {
                single(.failure(error))
            }
            return Disposables.create {}
        }
    }
}
