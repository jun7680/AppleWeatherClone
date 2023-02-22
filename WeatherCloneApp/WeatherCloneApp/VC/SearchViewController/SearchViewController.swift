//
//  SearchViewController.swift
//  WeatherCloneApp
//
//  Created by 옥인준 on 2023/02/22.
//

import UIKit
import RxSwift
import RxCocoa

protocol SelectedCountry: AnyObject {
    func selectedCountry(model: CityListResponse)
}

class SearchViewController: BaseViewController {
    
    private let viewModel = SearchViewModel()
    private let disposeBag = DisposeBag()
    
    weak var selectDelegate: SelectedCountry?
    
    private let searchListTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorColor = .white
        tableView.register(
            SearchListTableViewCell.self,
            forCellReuseIdentifier: SearchListTableViewCell.identifier
        )
        
        tableView.backgroundColor = .lightGray
        
        return tableView
    }()
    
    override func setup() {
        super.setup()
        view.backgroundColor = .lightGray
        view.addSubview(searchListTableView)

    }
    
    override func initConstraints() {
        super.initConstraints()
        
        searchListTableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func bind() {
        super.bind()
        
        viewModel.outputs.countryListObservable
            .bind(to: searchListTableView.rx.items(
                cellIdentifier: SearchListTableViewCell.identifier,
                cellType: SearchListTableViewCell.self)
            ) { index, item, cell in
                cell.configure(item)
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
                owner.viewModel.inputs.fetch()
            }.disposed(by: disposeBag)
        
        searchListTableView.rx.modelSelected(CityListResponse.self)
            .bind(with: self) { owner, model in
                owner.dismiss(animated: true) {
                    owner.selectDelegate?.selectedCountry(model: model)
                }
            }.disposed(by: disposeBag)
    }
}
