//
//  ViewController.swift
//  WeatherCloneApp
//
//  Created by 옥인준 on 2023/02/21.
//

import UIKit
import RxSwift
import RxDataSources
//import RxCocoa

class MainViewController: BaseViewController {
    
    private let disposeBag = DisposeBag()
    private let viewModel = MainViewModel()
    
    private var hourlyItems = [HourlyViewData]()
    private var weeklyItems = [WeekendViewData]()
    
    /// datasource
    private var dataSource: RxTableViewSectionedReloadDataSource<WeatherSectionModel>?
    
    private let weatherListTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.separatorStyle = .none
        
        tableView.backgroundColor = .clear
        
        return tableView
    }()
    
    override func setup() {
        super.setup()
        setTableViewDelegate()
        setRegisterCell()
        
        let views = [
            weatherListTableView
        ]
        view.addSubViews(views)
     
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
        bindDataSource()
        bindSections()
        
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
    
    /// delegate setting
    private func setTableViewDelegate() {
        weatherListTableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
    }
    
    /// cell register
    private func setRegisterCell() {
        weatherListTableView.register(
            RecentInfoTableViewCell.self,
            forCellReuseIdentifier: RecentInfoTableViewCell.identifier
        )
        weatherListTableView.register(
            HourlyTableViewCell.self,
            forCellReuseIdentifier: HourlyTableViewCell.identifier
        )
        weatherListTableView.register(
            WeekEndTableViewCell.self,
            forCellReuseIdentifier: WeekEndTableViewCell.identifier
        )
        weatherListTableView.register(
            LocationTableViewCell.self,
            forCellReuseIdentifier: LocationTableViewCell.identifier
        )
        weatherListTableView.register(
            DetailInfoTableViewCell.self,
            forCellReuseIdentifier: DetailInfoTableViewCell.identifier
        )
    }
}

// MARK: DataSource
extension MainViewController {
    
    private func bindDataSource() {
        dataSource = RxTableViewSectionedReloadDataSource(
            configureCell: { [weak self] _, tableview, indexpath, row in
                switch row {
                case let .recent(model):
                    self?.view.layoutIfNeeded()
                    if let image = UIImage(named: model.weather.icon) {
                        self?.view.backgroundColor = UIColor(patternImage: image)
                    } else {
                        self?.view.backgroundColor = .blue.withAlphaComponent(0.2)
                    }

                    return RecentInfoTableViewCell.makeCell(
                        tableview,
                        indexPath: indexpath,
                        model: model
                    )
                case let .hourly(model):
                    return HourlyTableViewCell.makeCell(
                        view: tableview,
                        indexPath: indexpath,
                        model: model
                    )
                case let .weekend(model):
                    return WeekEndTableViewCell.makeCell(
                        view: tableview,
                        indexPath: indexpath,
                        model: model
                    )
                case let .location(model):
                    return LocationTableViewCell.makeCell(
                        tableview,
                        indexPath: indexpath,
                        model: model
                    )
                case let .detail(model):
                    return DetailInfoTableViewCell.makeCell(
                        view: tableview,
                        indexPath: indexpath,
                        model: model
                    )
                }
        })
    }
    
    private func bindSections() {
        guard let dataSource else { return }
        viewModel.outputs.sectionsObservable
            .observe(on: MainScheduler.asyncInstance)
            .bind(to: weatherListTableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = WeatherInfoType(
            index: indexPath.section
        ) else { return 0 }

        return section.sectionHeight
    }
}

/// Delegate with SearchViewController action
extension MainViewController: SelectedCountry {
    func selectedCountry(model: CityListResponse) {
        viewModel.input.fetch(lat: model.coord.lat, lon: model.coord.lon)
    }
}
