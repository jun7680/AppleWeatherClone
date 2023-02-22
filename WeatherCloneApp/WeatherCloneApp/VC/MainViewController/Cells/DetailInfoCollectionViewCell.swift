//
//  DetailInfoCollectionViewCell.swift
//  WeatherCloneApp
//
//  Created by 옥인준 on 2023/02/21.
//

import UIKit

class DetailInfoCollectionViewCell: UICollectionViewCell {
    static let identifier = "DetailInfoCollectionViewCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    private let subTitleLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .blue.withAlphaComponent(0.2)
        clipsToBounds = true
        layer.cornerRadius = 16
        addViews()
        initConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addViews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(subTitleLabel)
    }
    
    private func initConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(16)
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    func configure(_ data: DetailDataType) {
        titleLabel.text = data.value.title
        subTitleLabel.text = data.value.value
    }
}
