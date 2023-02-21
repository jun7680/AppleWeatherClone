//
//  HourCollectionViewCell.swift
//  WeatherCloneApp
//
//  Created by 옥인준 on 2023/02/21.
//

import UIKit

class HourlyTableViewCell: BaseTableViewCell {
    static let identifier = "HourWeather"
    
    private var hourlyItems = [HourlyViewData]()
    
    private let collectionViewFlowLayout: UICollectionViewFlowLayout = {
      let layout = UICollectionViewFlowLayout()
      layout.scrollDirection = .horizontal
      layout.minimumLineSpacing = 8.0
      layout.minimumInteritemSpacing = 0
      layout.itemSize = .init(width: 44, height: 44)
      return layout
    }()
    
    private lazy var hourlyCollectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: contentView.frame,
            collectionViewLayout: collectionViewFlowLayout
        )
        collectionView.isScrollEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInset = .zero
        collectionView.backgroundColor = .clear
        collectionView.clipsToBounds = true
        collectionView.register(HourlyCollectionViewCell.self, forCellWithReuseIdentifier: HourlyCollectionViewCell.identifier)

        return collectionView
    }()
    
    override func setup() {
        super.setup()
        selectionStyle = .none
        clipsToBounds = true
        layer.cornerRadius = 16
        contentView.backgroundColor = .blue.withAlphaComponent(0.2)
        hourlyCollectionView.dataSource = self
        hourlyCollectionView.delegate = self
    }
    
    override func addViews() {
        super.addViews()
        
        contentView.addSubview(hourlyCollectionView)
        
    }
    
    override func initConstraints() {
        super.initConstraints()
        hourlyCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
    }
    
    func configure(_ items: [HourlyViewData]) {
        hourlyItems = items
        hourlyCollectionView.reloadData()
    }
}

extension HourlyTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hourlyItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: HourlyCollectionViewCell.identifier,
            for: indexPath
        ) as? HourlyCollectionViewCell else { return .init() }
        let item = hourlyItems[indexPath.row]
        cell.configure(item)
        
        return cell
    }
}

extension HourlyTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 44, height: 100)
    }
}
