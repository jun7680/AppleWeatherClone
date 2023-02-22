//
//  RecentInfoTableViewCell.swift
//  WeatherCloneApp
//
//  Created by 옥인준 on 2023/02/23.
//

import UIKit

class RecentInfoTableViewCell: BaseTableViewCell {
    static let identifier = "RecentInfoTableViewCell"
    
    private var model: HourlyViewData? {
        didSet {
            guard let model else { return }
            headerView.configure(model)
        }
    }
    
    private let headerView = HeaderView()
    
    override func setup() {
        super.setup()
        contentView.backgroundColor = .blue.withAlphaComponent(0.2)
    }
    override func addViews() {
        super.addViews()
        
        contentView.addSubview(headerView)
    }
    override func initConstraints() {
        super.initConstraints()
        
        headerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}

extension RecentInfoTableViewCell {
    static func makeCell(
        _ view: UITableView,
        indexPath: IndexPath,
        model: HourlyViewData
    ) -> RecentInfoTableViewCell {
        guard let cell = view.dequeueReusableCell(
            withIdentifier: identifier
        ) as? RecentInfoTableViewCell else { return .init() }
        
        cell.model = model
        
        return cell
    }
}
