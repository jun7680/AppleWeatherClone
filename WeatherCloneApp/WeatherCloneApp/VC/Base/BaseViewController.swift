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
    
    func setup() {
        view.backgroundColor = .white
        view.addSubview(searchBar)
    }
    
    func initConstraints() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }
    func bind() {}
    func subscribeUI() {}
    func errorPresent() {
        present(alert, animated: true)
    }
}
