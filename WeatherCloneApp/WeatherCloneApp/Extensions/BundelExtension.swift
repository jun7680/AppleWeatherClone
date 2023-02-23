//
//  BundelExtension.swift
//  WeatherCloneApp
//
//  Created by 옥인준 on 2023/02/21.
//

import Foundation

extension Bundle {
    /// API Key
    var appId: String {
        guard let path = self.url(forResource: "WeatherAPIInfo",
                                  withExtension: "plist"),
              let data = try? Data(contentsOf: path),
              let propertyList = try? PropertyListSerialization.propertyList(
                from: data,
                format: nil
              ) as? NSDictionary
        else { return "" }
        
        guard let appId = propertyList["API_KEY"] as? String
        else { fatalError("API_KEY not exist...") }
        
        return appId
    }
    
    /// Read Citylist.json
    var citiList: Data {
        guard let path = self.url(forResource: "citylist", withExtension: "json"),
              let data = try? Data(contentsOf: path)
        else { return Data() }
        
        return data
    }
}
