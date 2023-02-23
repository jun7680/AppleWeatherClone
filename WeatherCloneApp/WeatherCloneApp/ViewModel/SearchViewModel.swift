//
//  SearchViewModel.swift
//  WeatherCloneApp
//
//  Created by 옥인준 on 2023/02/22.
//

import Foundation
import RxSwift
import RxRelay

protocol SearchViewModelInput {
    func fetch()
    
    var countryListRelay: ReplayRelay<[CityListResponse]> { get }
}

protocol SearchViewModelOutput {
    var countryListObservable: Observable<[CityListResponse]> { get }
}

class SearchViewModel: SearchViewModelInput, SearchViewModelOutput {
    
    private let disposeBag = DisposeBag()
    
    var inputs: SearchViewModelInput { return self }
    var outputs: SearchViewModelOutput { return self }
    
    var countryListRelay = ReplayRelay<[CityListResponse]>.create(bufferSize: 1)
    var countryListObservable: Observable<[CityListResponse]> {
        return countryListRelay.asObservable()
    }
    
    init() {
        fetch()
    }
    
    func fetch() {
        WeatherService.readCityList()
            .subscribe(with: self) { owner, result in
                owner.countryListRelay.accept(result)
            }.disposed(by: disposeBag)
    }
}
