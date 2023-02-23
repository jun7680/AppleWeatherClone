//
//  SearchListTableViewCell.swift
//  WeatherCloneApp
//
//  Created by 옥인준 on 2023/02/22.
//

import UIKit

class SearchListTableViewCell: BaseTableViewCell {
    static let identifier = "SearchListTableViewCell"
    
    private let cityLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 16, weight: .bold)
        
        return label
    }()
    
    private let countryLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 16, weight: .bold)
        
        return label
    }()
    
    override func setup() {
        super.setup()
        
        selectionStyle = .default
        contentView.backgroundColor = .lightGray
    }
    
    override func addViews() {
        super.addViews()
        
        let views = [
            cityLabel,
            countryLabel
        ]
        
        contentView.addSubViews(views)
    }
    
    override func initConstraints() {
        super.initConstraints()
        
        cityLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(4)
        }
        
        countryLabel.snp.makeConstraints { make in
            make.top.equalTo(cityLabel.snp.bottom).offset(4)
            make.leading.equalTo(cityLabel)
            make.bottom.equalToSuperview().inset(4)
        }
    }
    
    func configure(_ item: CityListResponse) {
        cityLabel.text = item.name
        countryLabel.text = item.country
    }
}
