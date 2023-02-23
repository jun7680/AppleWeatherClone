//
//  File.swift
//  WeatherCloneApp
//
//  Created by 옥인준 on 2023/02/23.
//

import Foundation
import RxDataSources

// MARK: - DataSource Section Model
struct WeatherSectionModel {
    var items: [WeatherInfoModel]
}

enum WeatherInfoModel {
    case recent(_ items: HourlyViewData)
    case hourly(_ items: [HourlyViewData])
    case weekend(_ items: WeekendViewData)
    case location(_ items: LocationViewData)
    case detail(_ items: [DetailDataType])
}


extension WeatherSectionModel: SectionModelType {
    init(original: WeatherSectionModel, items: [WeatherInfoModel]) {
        self = original
        self.items = items
    }
}

