//
//  BearFriedViewModel.swift
//  RxSwift-Learning
//
//  Created by 고대원 on 2019/12/24.
//  Copyright © 2019 kodeawon. All rights reserved.
//

import Foundation

import RxSwift

protocol BearFriedViewModelType {
    var fetchMenus: AnyObserver<Void> { get }
    
    var allMenus: Observable<[MenuModel]> { get }
    var totalCountText: Observable<String> { get }
    var totalPriceText: Observable<String> { get }
}

class BearFriedViewModel: BearFriedViewModelType {
    
    var disposeBag = DisposeBag()
    
    var fetchMenus: AnyObserver<Void>
    
    var allMenus: Observable<[MenuModel]>
    var totalCountText: Observable<String>
    var totalPriceText: Observable<String>
    
    init(domain: MenuFetchable = MenuStore()) {
        let fetching = PublishSubject<Void>()
        
        let menus = BehaviorSubject<[MenuModel]>(value: [])
        let error = PublishSubject<Error>() //?
        
        ///INPUT
        fetchMenus = fetching.asObserver()
        
        fetching
            .do(onNext: { _ in  })
            .flatMap(domain.fetchMenus)
            .map { $0.map { MenuModel($0) } }
            .do(onNext: { _ in })
            .do(onError: { err in error.onNext(err) })
            .subscribe(onNext: menus.onNext)
            .disposed(by: disposeBag)
        
        ///OUTPUT
        allMenus = menus
        
        totalCountText = menus
            .map { $0.map { $0.count }.reduce(0, +) }
            .map { "\($0)" }
        
        totalPriceText = menus
            .map { $0.map { $0.price }.reduce(0, +) }
            .map { "\($0)" }
    }
}
