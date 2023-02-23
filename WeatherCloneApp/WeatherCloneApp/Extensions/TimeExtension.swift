//
//  DoubliExtenstion.swift
//  WeatherCloneApp
//
//  Created by 옥인준 on 2023/02/21.
//

import Foundation

extension Double {
    var convertingUTCtime: Date {
        return Date(timeIntervalSince1970: self)
    }
}

extension Date {
    var dtToTimeWithLetter: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "a h시"
        dateFormatter.locale = Locale(identifier: "ko-kr")
        return dateFormatter.string(from: self)
    }
    
    /// format: yyyy-MM-dd
    var dtToDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "ko-kr")
        return dateFormatter.string(from: self)
    }
    var dayOfWeek: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEEEE"
        formatter.locale = Locale(identifier:"ko_KR")
        let convertStr = formatter.string(from: self)
        return convertStr
    }
}
