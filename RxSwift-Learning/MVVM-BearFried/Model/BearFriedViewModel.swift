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
    var clearMenus: AnyObserver<Void> { get }
    var orderMenus: AnyObserver<Void> { get }
    var increaseMenuCount: AnyObserver<(item: MenuModel, inc: Int)> { get }
    
    var allMenus: Observable<[MenuModel]> { get }
    var actived: Observable<Bool> { get }
    var totalCountText: Observable<String> { get }
    var totalPriceText: Observable<String> { get }
}

class BearFriedViewModel: BearFriedViewModelType {
    
    var disposeBag = DisposeBag()
    
    var fetchMenus: AnyObserver<Void>
    var clearMenus: AnyObserver<Void>
    var orderMenus: AnyObserver<Void>
    var increaseMenuCount: AnyObserver<(item: MenuModel, inc: Int)>
    
    var allMenus: Observable<[MenuModel]>
    var actived: Observable<Bool>
    var totalCountText: Observable<String>
    var totalPriceText: Observable<String>
    
    init(domain: MenuFetchable = MenuStore()) {
        let fetching = PublishSubject<Void>()
        let clearing = PublishSubject<Void>()
        let ordering = PublishSubject<Void>()
        let increase = PublishSubject<(item: MenuModel, inc: Int)>()
        
        let menus = BehaviorSubject<[MenuModel]>(value: [])
        let activing = BehaviorSubject<Bool>(value: true)
        let error = PublishSubject<Error>() //?
        
        ///INPUT
        fetchMenus = fetching.asObserver()
        clearMenus = clearing.asObserver()
        orderMenus = ordering.asObserver()
        increaseMenuCount = increase.asObserver()
        
        fetching
            .do(onNext: { _ in activing.onNext(true) })
            .flatMap(domain.fetchMenus)
            .map { $0.map { MenuModel($0) } }
            .do(onNext: { _ in activing.onNext(false) })
            .do(onError: { err in error.onNext(err) })
            .subscribe(onNext: menus.onNext)
            .disposed(by: disposeBag)
        
        clearing
            .withLatestFrom(menus)
            .map({ $0.map {$0.countUpdated(0)} })
            .subscribe(onNext: menus.onNext)
            .disposed(by: disposeBag)
        
        ordering
            .withLatestFrom(menus)
            .map({ $0.filter { $0.count > 0 } })
            .do(onNext: { items in
                if items.count == 0 {
                    let err = NSError(domain: "Empty Order", code: -1, userInfo: nil)
                    error.onNext(err)
                }
            })
            .filter { $0.count > 0 }
        
        increase.map { $0.item.countUpdated(max(0, $0.item.count + $0.inc)) }
            .withLatestFrom(menus) { (updated, originals) -> [MenuModel] in
                originals.map {
                    guard $0.name == updated.name else { return $0 }
                    return updated
                }
            }
            .subscribe(onNext: menus.onNext)
            .disposed(by: disposeBag)
        
        ///OUTPUT
        allMenus = menus
        
        actived = activing.asObservable().distinctUntilChanged()
        
        totalCountText = menus
            .map { $0.map { $0.count }.reduce(0, +) }
            .map { "\($0)" }
        
        totalPriceText = menus
            .map { $0.map { ($0.price * $0.count) }.reduce(0, +) }
            .map { "\($0)" }
    }
}
