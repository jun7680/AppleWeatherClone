//
//  ViewController.swift
//  WeatherCloneApp
//
//  Created by 옥인준 on 2023/02/21.
//

import UIKit
import RxSwift
import RxCocoa

class MainViewController: BaseViewController {
    
    private let disposeBag = DisposeBag()
    private let viewModel = MainViewModel()
    
    private var hourlyItems = [HourlyViewData]()
    private var weeklyItems = [WeekendViewData]()
    
    private let weatherListTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.separatorStyle = .none
        tableView.register(
            HourlyTableViewCell.self,
            forCellReuseIdentifier: HourlyTableViewCell.identifier
        )
        tableView.register(
            WeekEndTableViewCell.self,
            forCellReuseIdentifier: WeekEndTableViewCell.identifier
        )
        tableView.register(
            DetailInfoTableViewCell.self,
            forCellReuseIdentifier: DetailInfoTableViewCell.identifier
        )
        tableView.backgroundColor = .clear
        
        return tableView
    }()
    
    override func setup() {
        super.setup()
        
        let views = [
            weatherListTableView
        ]
        view.addSubViews(views)
        weatherListTableView.dataSource = self
        weatherListTableView.delegate = self
        
        // TODO: - 날씨에 맞게 변경
        guard let image = UIImage(named: "sunny") else { return }
        view.backgroundColor = UIColor(patternImage: image)
        
    }
    
    override func initConstraints() {
        super.initConstraints()

        weatherListTableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
    }
    
    override func bind() {
        super.bind()
        
        viewModel.outputs.hourlyListObservable
            .bind(with: self) { owner, items in
                owner.hourlyItems = items
            }.disposed(by: disposeBag)
        
        viewModel.outputs.weeklyListObservable
            .bind(with: self) { owner, items in
                owner.weeklyItems = items
            }.disposed(by: disposeBag)
        
        viewModel.outputs.errorObservable
            .bind(with: self) { owner, _ in
                owner.errorPresent()
            }.disposed(by: disposeBag)
    }
    
    override func subscribeUI() {
        super.subscribeUI()
        
        searchBar.rx.textDidBeginEditing
            .bind(with: self) { owner, _ in
                let searchViewController = SearchViewController()
                searchViewController.selectDelegate = self
                searchViewController.modalPresentationStyle = .fullScreen
                owner.present(searchViewController, animated: true)
            }.disposed(by: disposeBag)
    }
}

extension MainViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return WeatherInfoType.numberOfSection
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = WeatherInfoType(index: section) else { return 0 }
        
        switch section {
        case .hourly: return 1
        case .weekend: return weeklyItems.count
        case .location: return 1
        case .detail: return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = WeatherInfoType(index: indexPath.section)
        else { fatalError("section in not exist...") }
        
        switch section {
        case .hourly:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: HourlyTableViewCell.identifier,
                for: indexPath
            ) as? HourlyTableViewCell else { return .init() }
            
            cell.configure(hourlyItems)
            
            return cell
            
        case .weekend:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: WeekEndTableViewCell.identifier, for: indexPath) as? WeekEndTableViewCell else { return .init() }
            let weekend = weeklyItems[indexPath.row]
            cell.configure(weekend)
            return cell
            
        case .detail:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: DetailInfoTableViewCell.identifier,
                for: indexPath
            ) as? DetailInfoTableViewCell else { return .init() }
            if let recentItem = hourlyItems.first {
                let items: [DetailDataType] = [
                    .clouds(value: recentItem.clouds),
                    .wind(value: recentItem.wind),
                    .humidity(value: recentItem.humidity)
                ]
                cell.configure(items)
            }
            return cell
            
        default: return .init()
        }
        
    }
}
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let headerview = HeaderView()
            guard let recentItem = hourlyItems.first else { return nil }
        
            headerview.configure(recentItem)
            return headerview
        }
        
        if section == 3 {
            let mapView = CurrentMapView()
            mapView.setLocation(
                lat: viewModel.outputs.coordinate.lat,
                lon: viewModel.outputs.coordinate.lon
            )
            return mapView
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 280
        } else if section == 3 {
            return 400
        } else {
            return CGFloat.leastNormalMagnitude
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = WeatherInfoType(index: indexPath.section) else { return 0 }
        
        switch section {
        case .hourly:
            return 100
        case .weekend: return 56
        case .detail: return 380
        default: return CGFloat.leastNormalMagnitude
        }
    }
}

extension MainViewController: SelectedCountry {
    func selectedCountry(model: CityListResponse) {
        viewModel.input.fetch(lat: model.coord.lat, lon: model.coord.lon)
    }
}
