//
//  DetailInfoTableViewCell.swift
//  WeatherCloneApp
//
//  Created by 옥인준 on 2023/02/21.
//

import UIKit

class DetailInfoTableViewCell: BaseTableViewCell {
    static let identifier = "DetailInfoTableCell"
    
    private let collectionViewFlowLayout: UICollectionViewFlowLayout = {
      let layout = UICollectionViewFlowLayout()
      layout.minimumLineSpacing = 8.0
      layout.minimumInteritemSpacing = 0
      return layout
    }()
    
    private lazy var detailCollectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: contentView.frame,
            collectionViewLayout: collectionViewFlowLayout
        )
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInset = .zero
        collectionView.backgroundColor = .clear
        collectionView.clipsToBounds = true
        collectionView.register(DetailInfoCollectionViewCell.self, forCellWithReuseIdentifier: DetailInfoCollectionViewCell.identifier)

        return collectionView
    }()
    
    private var detailItems = [DetailDataType]()
    
    override func setup() {
        super.setup()
        selectionStyle = .none
        
        detailCollectionView.dataSource = self
        detailCollectionView.delegate = self
    }
    
    override func addViews() {
        super.addViews()
        
        contentView.addSubview(detailCollectionView)
    }
    
    override func initConstraints() {
        super.initConstraints()
        detailCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configure(_ items: [DetailDataType]) {
        detailItems = items
        detailCollectionView.reloadData()
    }
}

extension DetailInfoTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return detailItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: DetailInfoCollectionViewCell.identifier,
            for: indexPath
        ) as? DetailInfoCollectionViewCell else { return .init() }
        let item = detailItems[indexPath.row]
        cell.configure(item)
        
        return cell
    }
}

extension DetailInfoTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    // 옆 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 2 - 1

        return CGSize(width: width, height: width)
    }
}
