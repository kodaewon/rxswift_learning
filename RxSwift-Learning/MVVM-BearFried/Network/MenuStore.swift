//
//  MenuStore.swift
//  RxSwift-Learning
//
//  Created by 고대원 on 2019/12/24.
//  Copyright © 2019 kodeawon. All rights reserved.
//

import Foundation

import RxSwift

protocol MenuFetchable {
    func fetchMenus() -> Observable<[MenuItem]>
}

class MenuStore: MenuFetchable {
    func fetchMenus() -> Observable<[MenuItem]> {
        struct Response: Decodable {
            let menus: [MenuItem]
        }

        return APIService.fetchAllMenusRx()
            .map { data in
                guard let response = try? JSONDecoder().decode(Response.self, from: data) else {
                    throw NSError(domain: "Decoding error", code: -1, userInfo: nil)
                }
                return response.menus
            }
    }
}
