//
//  CurrentWeatherTableViewCell.swift
//  WeatherCloneApp
//
//  Created by 옥인준 on 2023/02/21.
//

import UIKit
import SnapKit

class CurrentWeatherTableViewCell: BaseTableViewCell {
    static let identifier = "CurrentWeather"
    
    private let cityLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 30, weight: .semibold)
        label.textAlignment = .center
        return label
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 40, weight: .bold)
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 25)
        return label
    }()
    
    private let tempStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
        return stackView
    }()
    
    private let minTempLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 17)
        return label
    }()
    
    private let maxTempLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 17)
        return label
    }()
    
    override func addViews() {
        super.addViews()
        
        let views = [
            cityLabel,
            temperatureLabel,
            descriptionLabel,
            tempStackView
        ]
        
        let stackViewChild = [
            minTempLabel,
            maxTempLabel
        ]
        
        contentView.addSubViews(views)
        tempStackView.addArrageSubViews(stackViewChild)
        
    }
    
    override func initConstraints() {
        super.initConstraints()
        
        cityLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
        
        temperatureLabel.snp.makeConstraints { make in
            make.top.equalTo(cityLabel.snp.bottom).offset(16)
            make.centerX.equalTo(cityLabel)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(temperatureLabel.snp.bottom).offset(16)
            make.centerX.equalTo(cityLabel)
        }
        
        tempStackView.snp.makeConstraints { make in
            make.centerX.equalTo(cityLabel)
        }
    }
    
    func configure(_ item: HeaderViewData) {
        cityLabel.text = item.city
        temperatureLabel.text = item.temp
        descriptionLabel.text = item.weatherSatus
        minTempLabel.text = item.minTemp + " | "
        maxTempLabel.text = item.maxTemp
    }
}
