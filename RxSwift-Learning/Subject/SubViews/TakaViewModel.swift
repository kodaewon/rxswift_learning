//
//  TakaViewModel.swift
//  RxSwift-Learning
//
//  Created by 고대원 on 2020/01/07.
//  Copyright © 2020 kodeawon. All rights reserved.
//

import RxSwift
import RxCocoa

class TakaViewModel: TikiTakaProtocol {
    
    var disposeBag = DisposeBag()
        
    var intput: BehaviorSubject<String>
    
    var output: Observable<String>
    var send: AnyObserver<Void>
    var error: Observable<Error>
    
    init() {
        let intputOb = BehaviorSubject<String>(value: "")
        
        let outputOb = BehaviorSubject<String>(value: "")
        let sendOb = PublishSubject<Void>()
        let errorOb = PublishSubject<Error>()
        
//         Input
        intput = intputOb.asObserver()
        
        
        // Output
        output = outputOb.asObserver()
        send = sendOb.asObserver()
        error = errorOb.asObserver()
        
        sendOb
            .withLatestFrom(intputOb)
            .subscribe(onNext: { string in
                if string.isEmpty {
                    let error = NSError(domain: "isEmpty", code: -1, userInfo: nil)
                    errorOb.onNext(error)
                }else {
                    outputOb.onNext(string)
                }
            })
            .disposed(by: disposeBag)
    }
}
