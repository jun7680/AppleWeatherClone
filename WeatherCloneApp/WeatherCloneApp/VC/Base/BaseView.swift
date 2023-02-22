//
//  BaseView.swift
//  WeatherCloneApp
//
//  Created by 옥인준 on 2023/02/21.
//

import UIKit

class BaseView: UIView {

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
        addViews()
        initConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {}
    func addViews() {}
    func initConstraints() {}
}
