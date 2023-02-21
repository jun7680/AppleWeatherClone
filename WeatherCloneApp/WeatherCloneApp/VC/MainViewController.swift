//
//  ViewController.swift
//  WeatherCloneApp
//
//  Created by 옥인준 on 2023/02/21.
//

import UIKit
import RxSwift
import RxCocoa

class MainViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let viewModel = MainViewModel()
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search"
        searchBar.searchBarStyle = .minimal
        
        return searchBar
    }()
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupView()
        initConstraints()
    }
    
    private func setupView() {
        let views = [
            searchBar,
            weatherListTableView
        ]
        view.addSubViews(views)
        weatherListTableView.dataSource = self
        weatherListTableView.delegate = self
        
        // TODO: - 날씨에 맞게 변경
        guard let image = UIImage(named: "sunny") else { return }
        view.backgroundColor = UIColor(patternImage: image)
        
    }
    
    private func initConstraints() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        weatherListTableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
    }
    
    private func bind() {
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
        case .weekend: return 5
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
            
            let mockData: [HourlyViewData] = [
                .init(date: "월", icon: "01d", temp: 10),
                .init(date: "화", icon: "02d", temp: 15),
                .init(date: "수", icon: "03d", temp: -10),
                .init(date: "목", icon: "04d", temp: 10),
                .init(date: "금", icon: "09d", temp: -12),
                .init(date: "토", icon: "03d", temp: 10),
                .init(date: "월", icon: "03d", temp: 10),
                .init(date: "월", icon: "03d", temp: 10),
                .init(date: "월", icon: "03d", temp: 10),
                .init(date: "월", icon: "03d", temp: 10)
            ]
            cell.configure(mockData)
            
            return cell
            
        case .weekend:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: WeekEndTableViewCell.identifier, for: indexPath) as? WeekEndTableViewCell else { return .init() }
            cell.configure(.init(weekend: "월", icon: "01d", temp: (12, 47)))
            
//            if indexPath.row == 0 {
//                cell.roundCorners(corners: [.topLeft, .topRight], radius: 16)
//            } else if indexPath.row == 4 {
//                cell.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 16)
//            } else {
//                cell.layer.cornerRadius = 0
//            }
            return cell
            
        case .detail:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: DetailInfoTableViewCell.identifier,
                for: indexPath
            ) as? DetailInfoTableViewCell else { return .init() }
            let items: [DetailDataType] = [
                .clouds(value: 56),
                .wind(value: 56),
                .humidity(value: 56)
            ]
            cell.configure(items)
            return cell
            
        default: return .init()
        }
        
    }
}
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let headerview = HeaderView()
            headerview.configure(.init(city: "서울", temp: 17, minTemp: -4, maxTemp: 14, weatherSatus: "맑음"))
            return headerview
        }
        
        if section == 3 {
            let mapView = CurrentMapView()
            mapView.setLocation()
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
