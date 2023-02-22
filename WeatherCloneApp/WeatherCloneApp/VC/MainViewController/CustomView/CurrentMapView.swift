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
        mapview.layer.cornerRadius = 16
        return mapview
    }()
    
    override func setup() {
        super.setup()
        
    }
    
    override func addViews() {
        super.addViews()
        addSubview(mapView)
    }
    
    override func initConstraints() {
        super.initConstraints()
        mapView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func setLocation(lat: Double, lon: Double) {
        mapView.annotations.forEach {
            mapView.removeAnnotation($0)
        }
        let location = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        let region = MKCoordinateRegion(
            center: location,
            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        )
        mapView.setRegion(region, animated: false)
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2DMake(lat, lon)
        annotation.title = "검색 위치"
        
        mapView.addAnnotation(annotation)
    }
}
