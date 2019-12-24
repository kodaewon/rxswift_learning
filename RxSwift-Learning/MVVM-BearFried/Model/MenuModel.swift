//
//  MenuModel.swift
//  RxSwift-Learning
//
//  Created by 고대원 on 2019/12/24.
//  Copyright © 2019 kodeawon. All rights reserved.
//

import Foundation

struct MenuItem: Decodable {
    var name: String
    var price: Int
}

extension MenuItem: Equatable {
    static func == (lhs: MenuItem, rhs: MenuItem) -> Bool {
        return lhs.name == rhs.name && lhs.price == rhs.price
    }
}


struct MenuModel: Decodable {
    var name: String
    var count: Int
    var price: Int
    
    init(_ item: MenuItem) {
        name = item.name
        price = item.price
        count = 0
    }
    
    init(_ name: String, _ count: Int, _ price: Int) {
        self.name = name
        self.price = price
        self.count = count
    }
}

extension MenuModel: Equatable {
    static func == (lhs: MenuModel, rhs: MenuModel) -> Bool {
        return lhs.name == rhs.name && lhs.price == rhs.price
    }
}
