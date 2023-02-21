//
//  ViewExtensions.swift
//  WeatherCloneApp
//
//  Created by 옥인준 on 2023/02/21.
//

import UIKit

extension UIView {
    func addSubViews(_ views: [UIView]) {
        views.forEach {
            addSubview($0)
        }
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
}

extension UIStackView {
    func addArrageSubViews(_ child: [UIView]) {
        child.forEach {
            addArrangedSubview($0)
        }
    }
}
