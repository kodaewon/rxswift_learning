//
//  TikiTakaProtocol.swift
//  RxSwift-Learning
//
//  Created by 고대원 on 2020/01/07.
//  Copyright © 2020 kodeawon. All rights reserved.
//

import RxSwift
import RxCocoa

protocol TikiTakaProtocol {
    var intput: BehaviorSubject<String> { get }
    
    var output: Observable<String> { get }
    var send: AnyObserver<Void> { get }
    var error: Observable<Error> { get }
}
