//
//  CurrentMapView.swift
//  WeatherCloneApp
//
//  Created by 옥인준 on 2023/02/21.
//

import UIKit
import MapKit

class CurrentMapView: BaseView {
    
    private let mapView: MKMapView = {
        let mapview = MKMapView()
        mapview.isScrollEnabled = false
        
        return mapview
    }()

    override func setup() {
        super.setup()
    }
    
    override func addViews() {
        super.addViews()
//        containerView.addSubview(mapView)
//        containerView.addSubview(titleLabel)
        addSubview(mapView)
    }
    
    override func initConstraints() {
        super.initConstraints()
//        containerView.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
//        titleLabel.snp.makeConstraints { make in
//            make.top.leading.equalToSuperview().inset(8)
//        }
        mapView.snp.makeConstraints { make in
//            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.top.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func setLocation() {
        let location = CLLocationCoordinate2D(latitude: 36.783611, longitude: 127.004173)
        let region = MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        mapView.setRegion(region, animated: true)
        let annotation = MKPointAnnotation()
           annotation.coordinate = CLLocationCoordinate2DMake(36.783611, 127.004173)
           annotation.title = "여기"
           
        mapView.addAnnotation(annotation)
    }
}
