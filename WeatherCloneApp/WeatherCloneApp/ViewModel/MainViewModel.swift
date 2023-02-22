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
    
    var infoListRelay: PublishRelay<[WeatherInfoType]> { get }
    var hourlyListRelay: PublishRelay<[HourlyViewData]> { get }
    var weeklyListRelay: PublishRelay<[WeekendViewData]> { get }
    var buildFinishRelay: PublishRelay<Void> { get }
    var coordinateInput: (lat: Double, lon: Double) { get set }
}

protocol MainViewModelOuput {
    var infoListRelayObservable: Observable<[WeatherInfoType]> { get }
    var hourlyListObservable: Observable<[HourlyViewData]> { get }
    var weeklyListObservable: Observable<[WeekendViewData]> { get }
    var buildFinishObservable: Observable<Void> { get }
    
    var coordinate: (lat: Double, lon: Double) { get }
}

class MainViewModel: MainViewModelInput, MainViewModelOuput {
    
    var input: MainViewModelInput { return self }
    var outputs: MainViewModelOuput { return self }
    
    private let disposeBag = DisposeBag()
    
    var infoListRelay = PublishRelay<[WeatherInfoType]>()
    var infoListRelayObservable: Observable<[WeatherInfoType]> {
        return infoListRelay.asObservable()
    }
    
    var hourlyListRelay = PublishRelay<[HourlyViewData]>()
    var hourlyListObservable: Observable<[HourlyViewData]> {
        return hourlyListRelay.asObservable()
    }
    
    var weeklyListRelay = PublishRelay<[WeekendViewData]>()
    var weeklyListObservable: Observable<[WeekendViewData]> {
        return weeklyListRelay.asObservable()
    }
    
    var buildFinishRelay = PublishRelay<Void>()
    var buildFinishObservable: Observable<Void> {
        return buildFinishRelay.asObservable()
    }
    
    var coordinateInput: (lat: Double, lon: Double) = (36.783611, 127.004173)
    var coordinate: (lat: Double, lon: Double) {
        return coordinateInput
    }
    
    init() {
        fetch(lat: coordinateInput.lat, lon: coordinateInput.lon)
        
        Observable.zip(hourlyListRelay, weeklyListRelay)
            .subscribe(with: self) { owner, items in
                owner.buildFinishRelay.accept(())
            }.disposed(by: disposeBag)
    }
    
    func fetch(lat: Double, lon: Double) {
        coordinateInput = (lat, lon)
        
        WeatherService.fetch(lat: lat, lon: lon)
            .subscribe(with: self) { owner, result in
                // 가장 최근의 값 가져 오기 위해
                owner.makeWeekendViewData(result.list)
                let filteredData = result.list.filter { $0.dt >= Date().timeIntervalSince1970 }
                
                owner.makeHourlyViewData(filteredData, lat: lat, lon: lon)
            }.disposed(by: disposeBag)
    }
    
    private func makeHourlyViewData(_ items: [WeatherList], lat: Double, lon: Double) {
        LocationManager.reverseParsing(lat: lat, lon: lon) { [weak self] address in
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
                    wind: $0.wind.speed
                )
            }
            hourlyItems.removeSubrange(24...hourlyItems.count - 1)
            self?.hourlyListRelay.accept(hourlyItems)
        }
    }
    
    private func makeWeekendViewData(_ items: [WeatherList]) {
        var minDictonary: [String: WeekendViewData] = [:]
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
        let weeklyItems = minDictonary.sorted(by: { $0.key < $1.key }).map { return $1 }
        
        weeklyListRelay.accept(weeklyItems)
        
    }
}
