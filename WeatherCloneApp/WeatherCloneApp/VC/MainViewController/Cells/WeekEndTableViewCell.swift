//
//  WeekEndTableViewCell.swift
//  WeatherCloneApp
//
//  Created by 옥인준 on 2023/02/21.
//

import UIKit

class WeekEndTableViewCell: BaseTableViewCell {
    static let identifier = "WeekEnd"
    
    private let weekendLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 16)
        
        return label
    }()
    
    private let weekendIcon: UIImageView = {
        let imageView = UIImageView()
        
        return imageView
    }()
    
    private let weekendMinLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 16)
        
        return label
    }()
    
    private let weekendMaxLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 16, weight: .semibold)

        return label
    }()
    
    private let tempStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
        return stackView
    }()
    
    override func setup() {
        super.setup()
        clipsToBounds = true
        selectionStyle = .none
        contentView.backgroundColor = .blue.withAlphaComponent(0.2)
    }
    
    override func addViews() {
        super.addViews()
        
        let views = [
            weekendLabel,
            weekendIcon,
            tempStackView
            
        ]
        
        let chids = [
            weekendMinLabel,
            weekendMaxLabel
        ]
        tempStackView.addArrageSubViews(chids)
        contentView.addSubViews(views)
    }
    
    override func initConstraints() {
        super.initConstraints()
        
        weekendLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(4)
            make.leading.equalToSuperview().inset(10)
            make.centerY.equalToSuperview()
        }
        
        weekendIcon.snp.makeConstraints { make in
            make.leading.equalTo(weekendLabel.snp.trailing).offset(100)
            make.centerY.equalToSuperview()
            make.size.equalTo(36)
        }
        
        tempStackView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(4)
            make.centerY.equalToSuperview()
        }
    }
    
    func configure(_ item: WeekendViewData) {
        weekendLabel.text = item.weekend
        weekendIcon.image = UIImage(named: item.icon)
        weekendMinLabel.text = "최소: \(item.temp.min)º"
        weekendMaxLabel.text = "최대: \(item.temp.max)º"
    }
    
}
