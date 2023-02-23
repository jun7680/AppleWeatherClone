//
//  MainViewModel.swift
//  WeatherCloneApp
//
//  Created by 옥인준 on 2023/02/21.
//

import Foundation
import RxRelay
import RxSwift

protocol MainViewModelInput {
    func fetch(lat: Double, lon: Double)
    
    var hourlyReadyRelay: PublishRelay<Void> { get }
    var weeklyReadyRelay: PublishRelay<Void> { get }
    var sections: BehaviorRelay<[WeatherSectionModel]> { get }
    var errorRelay: PublishRelay<Void> { get }
    
}

protocol MainViewModelOuput {
    var sectionsObservable: Observable<[WeatherSectionModel]> { get }
    var errorObservable: Observable<Void> { get }
}

class MainViewModel: MainViewModelInput, MainViewModelOuput {
    
    var input: MainViewModelInput { return self }
    var outputs: MainViewModelOuput { return self }
    
    private let disposeBag = DisposeBag()
    var hourlyReadyRelay = PublishRelay<Void>()
    var weeklyReadyRelay = PublishRelay<Void>()
    
    var coordinate: (lat: Double, lon: Double) = (36.783611, 127.004173)
    /// tableview section
    var sections = BehaviorRelay<[WeatherSectionModel]>(value: [])
    var sectionsObservable: Observable<[WeatherSectionModel]> {
        return sections.asObservable()
    }
    
    /// Error Relay
    var errorRelay = PublishRelay<Void>()
    var errorObservable: Observable<Void> {
        return errorRelay.asObservable()
    }
    
    /// 3시간 단위 아이템
    private var hourlItems: [HourlyViewData]?
    
    /// 5일간 아이템
    private var weeklyItems: [WeekendViewData]?
    
    /// 최신 섹션
    private var recentSection: WeatherSectionModel? {
        guard let recent = hourlItems?.first else { return nil }
        
        return WeatherSectionModel(items: [.recent(recent)])
    }
    
    /// 시간 섹션
    private var hourlySection: WeatherSectionModel? {
        guard let hourlItems else { return nil }

        return WeatherSectionModel(items: [.hourly(hourlItems)])
    }
    
    /// 5일간 섹션
    private var weeklySection: WeatherSectionModel? {
        guard let weeklyItems else { return nil }
        let weekly = weeklyItems.compactMap {
            return WeatherInfoModel.weekend($0)
        }
        return WeatherSectionModel(items: weekly)
    }
    
    /// 위치 섹션
    private var locationSection: WeatherSectionModel? {
        let (lat, lon) = coordinate
        let model = LocationViewData(lat: lat, lon: lon)
        return WeatherSectionModel(items: [.location(model)])
    }
    
    /// 디테일 섹션
    private var detailSection: WeatherSectionModel? {
        guard let detailItem = hourlItems?.first else { return nil }
        let model: [DetailDataType] = [
            .clouds(value: detailItem.clouds),
            .humidity(value: detailItem.humidity),
            .wind(value: detailItem.wind)
        ]
        
        return WeatherSectionModel(items: [.detail(model)])
    }
    
    /// DataSource All Seection
    private var weatherSections: [WeatherSectionModel] {
        return [
            recentSection,
            hourlySection,
            weeklySection,
            locationSection,
            detailSection
        ].compactMap { $0 }
    }
    
    // MARK: - init
    init() {
        bindFinishRelay()
        fetch(lat: coordinate.lat, lon: coordinate.lon)
    }
    
    /// MARK: - fetch weather info
    func fetch(lat: Double, lon: Double) {
        coordinate = (lat, lon)
        
        WeatherService.fetch(lat: lat, lon: lon)
            .subscribe(with: self, onSuccess: { owner, result in
                owner.makeWeekendViewData(result.list)
                
                // 가장 최근의 값 가져 오기 위해
                let filteredData = result.list.filter {
                    $0.dt >= Date().timeIntervalSince1970
                }
                owner.makeHourlyViewData(filteredData, lat: lat, lon: lon)
                
            }, onFailure: { owner, error in
                owner.errorRelay.accept(())
            }).disposed(by: disposeBag)
    }
}

// MARK: - private function
extension MainViewModel {
    
    /// bindFinishRelay
    private func bindFinishRelay() {
        Observable.zip(weeklyReadyRelay, hourlyReadyRelay)
            .bind(with: self) { owner, _ in
                owner.sections.accept(owner.weatherSections)
            }.disposed(by: disposeBag)
    }
    
    /// hourlyViewData build
    private func makeHourlyViewData(_ items: [WeatherList], lat: Double, lon: Double) {
        LocationManager.reverseParsing(lat: lat, lon: lon) { [weak self] address in
            guard let self else { return }
            var hourlyItems = items.map {
                return HourlyViewData(
                    city: address,
                    date: $0.dt.convertingUTCtime.dtToTimeWithLetter,
                    icon: $0.weather[0].icon,
                    temp: $0.main.temp,
                    minTemp: $0.main.tempMin,
                    maxTemp: $0.main.tempMax,
                    weatherSatus: $0.weather[0].description,
                    humidity: $0.main.humidity,
                    clouds: $0.clouds.all,
                    wind: $0.wind.speed,
                    weather: $0.weather[0].main
                )
            }
            hourlyItems.removeSubrange(24...hourlyItems.count - 1)
            self.hourlItems = hourlyItems
            self.hourlyReadyRelay.accept(())
        }
    }
    
    /// weekendViewData Build
    private func makeWeekendViewData(_ items: [WeatherList]) {
        var minDictonary: [String: WeekendViewData] = [:]
        // 최고, 최저 온도 구하기 위한 로직
        items.forEach {
            if minDictonary[$0.dtToDate] == nil {
                let data = WeekendViewData(
                    weekend: $0.dayOfWeek,
                    icon: $0.weather[0].icon,
                    temp: ($0.main.tempMin, $0.main.tempMax)
                )
                minDictonary.updateValue(data, forKey: $0.dtToDate)
            } else {
                if minDictonary[$0.dtToDate]!.temp.min > $0.main.tempMin {
                    minDictonary[$0.dtToDate]!.temp.min = $0.main.tempMin
                }
                
                if minDictonary[$0.dtToDate]!.temp.max < $0.main.tempMax {
                    minDictonary[$0.dtToDate]!.temp.max = $0.main.tempMax
                }
            }
        }
        let weeklyItems = minDictonary.sorted(by: { $0.key < $1.key })
            .map { return $1 }
        self.weeklyItems = weeklyItems
        weeklyReadyRelay.accept(())
    }
    
}
