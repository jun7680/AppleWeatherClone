//
//  CurrentWeatherTableViewCell.swift
//  WeatherCloneApp
//
//  Created by 옥인준 on 2023/02/21.
//

import UIKit
import SnapKit

class HeaderView: BaseView {
    
    private let cityLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 45, weight: .semibold)
        label.textAlignment = .center
        return label
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 60, weight: .bold)
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 40)
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
        label.font = .systemFont(ofSize: 20)
        return label
    }()
    
    private let maxTempLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 20)
        return label
    }()
    
    override func setup() {
        super.setup()
        backgroundColor = .clear
    }
    
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
        
        addSubViews(views)
        tempStackView.addArrageSubViews(stackViewChild)
        
    }
    
    override func initConstraints() {
        super.initConstraints()
        
        cityLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.centerX.equalToSuperview()
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
            make.top.equalTo(descriptionLabel.snp.bottom).offset(16)
            make.centerX.equalTo(cityLabel)
            make.bottom.equalToSuperview().inset(16)
        }
    }
    
    func configure(_ item: HourlyViewData) {
        cityLabel.text = item.city
        temperatureLabel.text = "\(item.temp)º"
        descriptionLabel.text = item.weatherSatus
        minTempLabel.text = "최저: \(item.minTemp)º | "
        maxTempLabel.text = "최고: \(item.maxTemp)º"
    }
}
