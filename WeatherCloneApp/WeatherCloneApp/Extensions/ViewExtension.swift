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
}

extension UIStackView {
    func addArrageSubViews(_ child: [UIView]) {
        child.forEach {
            addArrangedSubview($0)
        }
    }
}
