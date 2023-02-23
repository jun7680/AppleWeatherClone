//
//  BaseViewController.swift
//  WeatherCloneApp
//
//  Created by 옥인준 on 2023/02/22.
//

import UIKit

class BaseViewController: UIViewController {
    
    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search"
        searchBar.searchBarStyle = .minimal
        
        return searchBar
    }()
    
    private let alert: UIAlertController = {
        let alert = UIAlertController(
            title: nil,
            message: "에상치 못한 에러가 발생하였습니다.\n잠시 후 다시 시도해주세요.",
            preferredStyle: .alert
        )
        
        let defaultAction = UIAlertAction(title: "확인", style: .default)
        alert.addAction(defaultAction)
        return alert
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        initConstraints()
        bind()
        subscribeUI()
    }
    
    /// setup view ex:) addview, backgroudcolor etc..
    func setup() {
        view.backgroundColor = .white
        view.addSubview(searchBar)
    }
    /// init Constraints
    func initConstraints() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }
    /// Binding with data
    func bind() {}
    /// Subscribie to UI Interaction
    func subscribeUI() {}
    /// Error Alert present
    func errorPresent() {
        present(alert, animated: true)
    }
}
