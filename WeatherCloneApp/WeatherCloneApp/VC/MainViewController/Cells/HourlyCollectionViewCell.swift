//
//  HourlyCollectionViewCell.swift
//  WeatherCloneApp
//
//  Created by 옥인준 on 2023/02/21.
//

import UIKit

class HourlyCollectionViewCell: UICollectionViewCell {
    static let identifier = "HourlyCollectionViewCell"
    
    private var model: HourlyViewData? {
        didSet {
            guard let model else { return }
            dateLabel.text = model.date
            weatherImageView.image = UIImage(named: model.icon)
            tempLabel.text = "\(model.temp)º"
        }
    }
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 12)
        label.textAlignment = .center
        return label
    }()
    
    private let weatherImageView: UIImageView = {
        let imageView = UIImageView()
        
        return imageView
    }()
    
    private let tempLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 12)
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        setupViews()
        initConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        
        let views = [
            dateLabel,
            weatherImageView,
            tempLabel
        ]
        
        contentView.addSubViews(views)
       
    }
    
    private func initConstraints() {
        dateLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        weatherImageView.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom)
            make.centerX.equalTo(dateLabel)
            make.centerY.equalToSuperview()
            make.size.equalTo(24)
        }
        
        tempLabel.snp.makeConstraints { make in
            make.top.equalTo(weatherImageView.snp.bottom).offset(4)
            make.centerX.equalTo(dateLabel)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    func configure(_ item: HourlyViewData) {
        let icon: String
        switch item.weather {
        case .clouds: icon = "04d"
        case .rain: icon = "11d"
        case .snow: icon = "13d"
        case .sunny: icon = "01d"
        }
        dateLabel.text = item.date
        weatherImageView.image = UIImage(named: item.icon) ?? UIImage(named: icon)
        
        tempLabel.text = "\(item.temp)º"
    }
}


extension HourlyCollectionViewCell {
    static func makeCell(
        _ view: UICollectionView,
        indexPath: IndexPath,
        model: HourlyViewData
    ) -> HourlyCollectionViewCell {
        guard let cell = view.dequeueReusableCell(
            withReuseIdentifier: identifier,
            for: indexPath
        ) as? HourlyCollectionViewCell else { return .init() }
        
        cell.model = model
        
        return cell
    }
}
