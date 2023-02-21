//
//  SessionManager.swift
//  WeatherCloneApp
//
//  Created by 옥인준 on 2023/02/21.
//

import Foundation
import Alamofire
import RxSwift

protocol Request {
    static func request<T: Codable>(_ : T.Type?, apiType: APIType) -> Single<T>
}

enum NetworkError: Error {
    case emptyResponse
    case decodingError
    case unknown
}

class SessionManager: Request {
    
    static func request<T: Codable>(_: T.Type?, apiType: APIType) -> Single<T> {
        return Single<T>.create { single in
            AF.request(
                apiType.url,
                method: apiType.method,
                parameters: apiType.params
            ).responseData { result in
                switch result.result {
                case .success(let data):
                    do {
                        
                        /// 성공은 했지만 결과가 비어있을때
                        guard !data.isEmpty else {
                            single(.failure(NetworkError.emptyResponse))
                            return
                        }
                        let model: T = try JSONDecoder().decode(T.self, from: data)
                        
                        single(.success(model))
                    } catch {
                        print(error)
                        single(.failure(NetworkError.decodingError))
                    }
                case .failure(let error):
                    print(error)
                    single(.failure(error))
                }
            }
            
            return Disposables.create {}
        }
    }
}
