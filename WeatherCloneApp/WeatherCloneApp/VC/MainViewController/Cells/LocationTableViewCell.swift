//
//  LocationTableViewCell.swift
//  WeatherCloneApp
//
//  Created by 옥인준 on 2023/02/23.
//

import UIKit

class LocationTableViewCell: BaseTableViewCell {
    static let identifier = "LocationTableViewCell"
    
    private var model: LocationViewData? {
        didSet {
            guard let model else { return }
            locationView.setLocation(lat: model.lat, lon: model.lon)
        }
    }
    private let locationView = CurrentMapView()
    
    override func setup() {
        super.setup()
    }
    
    override func addViews() {
        super.addViews()
        contentView.addSubview(locationView)
    }
    
    override func initConstraints() {
        super.initConstraints()
        
        locationView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
    }
}

extension LocationTableViewCell {
    static func makeCell(
        _ view: UITableView,
        indexPath: IndexPath,
        model: LocationViewData
    ) -> LocationTableViewCell {
        guard let cell = view.dequeueReusableCell(
            withIdentifier: identifier
        ) as? LocationTableViewCell else { return .init() }
        
        cell.model = model
        
        return cell
    }
}
