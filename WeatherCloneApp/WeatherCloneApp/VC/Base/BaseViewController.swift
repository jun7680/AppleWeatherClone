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
}
