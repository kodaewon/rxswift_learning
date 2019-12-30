//
//  MenuModel.swift
//  RxSwift-Learning
//
//  Created by 고대원 on 2019/12/24.
//  Copyright © 2019 kodeawon. All rights reserved.
//

import Foundation

struct MenuModel: Codable {
    var name: String
    var price: Int
    var count: Int
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = (try? values.decode(String.self, forKey: .name)) ?? ""
        price = (try? values.decode(Int.self, forKey: .price)) ?? 0
        count = (try? values.decode(Int.self, forKey: .count)) ?? 0
    }
    
    init(_ item: MenuModel) {
        name = item.name
        price = item.price
        count = item.count
    }
    
    init(_ name: String, _ price: Int, _ count: Int) {
        self.name = name
        self.price = price
        self.count = count
    }
    
    func countUpdated(_ count: Int) -> MenuModel {
        return MenuModel(name, price, count)
    }
}

extension MenuModel: Equatable {
    static func == (lhs: MenuModel, rhs: MenuModel) -> Bool {
        return lhs.name == rhs.name && lhs.price == rhs.price
    }
}
