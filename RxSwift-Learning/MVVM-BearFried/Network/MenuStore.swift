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
    func fetchMenus() -> Observable<[MenuModel]>
}

class MenuStore: MenuFetchable {
    func fetchMenus() -> Observable<[MenuModel]> {
        struct Response: Codable {
            let menus: [MenuModel]
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
