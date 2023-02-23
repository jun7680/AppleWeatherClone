//
//  WeatherAPI.swift
//  WeatherCloneApp
//
//  Created by 옥인준 on 2023/02/21.
//

import Foundation
import Alamofire

enum WeatherAPI {
    case fetch(lat: Double, lon: Double)
}

extension WeatherAPI: APIType {
    var url: URL {
        guard let url = URL(string: baseURL + path)
        else { fatalError("URL is not exist...") }
        
        return url
    }
    
    var baseURL: String {
        return "https://api.openweathermap.org"
    }
    
    var path: String {
        switch self {
        case .fetch: return "/data/2.5/forecast"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetch: return .get
        }
    }
    
    var params: [String : Any] {
        switch self {
        case let .fetch(lat, lon):
            return [
                "lat" : lat,
                "lon" : lon,
                "lang" : "KR",
                "units" : "metric",
                "appid" : Bundle.main.appId
            ]
        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
        case .fetch: return URLEncoding.queryString
        }
    }
}
