//
//  APIType.swift
//  WeatherCloneApp
//
//  Created by 옥인준 on 2023/02/21.
//

import Foundation
import Alamofire
import RxSwift

protocol APIType {
    var url: URL { get }
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var params: [String: Any] { get }
    var encoding: ParameterEncoding { get }
}
