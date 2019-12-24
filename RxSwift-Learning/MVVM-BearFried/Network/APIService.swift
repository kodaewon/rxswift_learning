//
//  APIService.swift
//  RxSwift-Learning
//
//  Created by 고대원 on 2019/12/24.
//  Copyright © 2019 kodeawon. All rights reserved.
//

import Foundation

import RxSwift

class APIService {
    static let menuURL = "https://firebasestorage.googleapis.com/v0/b/rxswiftin4hours.appspot.com/o/fried_menus.json?alt=media&token=42d5cb7e-8ec4-48f9-bf39-3049e796c936"
    
    static func fetchAllMenusRx() -> Observable<Data> {
        return Observable<Data>.create({ observable in
            fetchAllMenus() { result in
                switch result {
                case let .success(data):
                    observable.onNext(data)
                    observable.onCompleted()
                case let .failure(err):
                    observable.onError(err)
                    break
                }
            }
            
            return Disposables.create()
        })
    }
    
    static func fetchAllMenus(completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: menuURL) else {
            completion(.failure(NSError(domain: "URL Fail", code: 0, userInfo: nil)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            if let err = err {
                completion(.failure(err))
                return
            }
            
            guard let data = data else {
                var code = 0
                if let httpResponse = response as? HTTPURLResponse {
                    code = httpResponse.statusCode
                }
                
                completion(.failure(NSError(domain: "No Data",
                                            code: code,
                                            userInfo: nil)))
                return
            }
            
            completion(.success(data))
        }.resume()
    }
}
