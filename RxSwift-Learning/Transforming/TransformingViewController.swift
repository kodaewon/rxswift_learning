//
//  TransformingViewController.swift
//  RxSwift-Learning
//
//  Created by 고대원 on 2019/12/23.
//  Copyright © 2019 kodeawon. All rights reserved.
//

import UIKit

import RxSwift

class TransformingViewController: UITableViewController {
    
    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Transforming"
    }
}

//MARK: - UITableViewDelegate
extension TransformingViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            rxswiftBuffer()
        case 1:
            rxswiftDelaySubscription()
        case 2:
            rxswiftFlatMap()
        case 3:
            rxswiftFlatMapFirst()
        case 4:
            rxswiftFlatMapLatest()
        case 5:
            rxswiftMap()
        case 6:
            rxswiftMapWithIndex()
        case 7:
            rxswiftScan()
        case 8:
            rxswiftToArray()
        default:
            break
        }
    }
}

//MARK: - Rxswift
extension TransformingViewController {
    func rxswiftBuffer() {
        let observableInts = Observable<Int>.of(1, 2, 3,4 ,5)
        
        observableInts
            .buffer(timeSpan: .milliseconds(1 * 100), count: 4, scheduler: MainScheduler.instance)
            .subscribe(onNext: { value in
                print("buffer = \(value)")
            })
            .disposed(by: disposeBag)
    }
    
    func rxswiftDelaySubscription() {
        let observableInts = Observable<Int>.of(1, 2, 3, 4, 5, 6, 7)
        
//        구독을 지연시켜 관찰 가능한 시퀀스를 전환합니다.
        observableInts
            .delaySubscription(.milliseconds(1 * 300), scheduler: MainScheduler.instance)
            .do(onNext: { value in
                print("delaySubscription do = \(value)")
            })
            .subscribe(onNext: { value in
                print("delaySubscription = \(value)")
            })
            .disposed(by: disposeBag)
        
//        오류 이벤트는 지연되지 않습니다.
        observableInts
                   .delay(.milliseconds(1 * 300), scheduler: MainScheduler.instance)
                   .do(onNext: { value in
                       print("delay do = \(value)")
                   })
                   .subscribe(onNext: { value in
                       print("delay = \(value)")
                   })
                   .disposed(by: disposeBag)
    }
    
    func rxswiftFlatMap() {
        let observableInts = Observable<Int>.of(1, 2, 3)
        
        let observableTenInts = Observable<Int>.of(10, 20)
        
        observableInts
            .flatMap { (value) -> Observable<Int> in
                return observableTenInts
            }
            .subscribe(onNext: { value in
                print("flatMap = \(value)")
            })
            .disposed(by: disposeBag)
    }
    
    func rxswiftFlatMapFirst() {
        let observableInts = Observable<Int>.of(1, 2, 3)
        
        let observableTenInts = Observable<Int>.of(10, 20)
        
        observableInts.flatMapFirst{ _ in observableTenInts }
            .subscribe(onNext: { value in
                print("flatMapFirst = \(value)")
            })
            .disposed(by: disposeBag)
        /// observableTenInts 끝나고 난후에 observableInts에서 subscribe이 일어난다면 마지막 기준으로 한번더 불러진다
    }
    
    func rxswiftFlatMapLatest() {
        let observableInts = Observable<Int>.of(1, 2, 3)
        
        let observableTenInts = Observable<Int>.of(10, 20)
        
        observableInts.flatMapLatest{ _ in observableTenInts }
            .subscribe(onNext: { value in
                print("flatMapLatest = \(value)")
            })
            .disposed(by: disposeBag)
    }
    
    func rxswiftMap() {
        let observableInts = Observable<Int>.of(1, 2, 3)
        
        observableInts.map { $0 + 10 }
            .subscribe(onNext: { value in
                print("map = \(value)")
            })
            .disposed(by: disposeBag)
    }
    
    func rxswiftMapWithIndex() {
        let observableInts = Observable<Int>.of(1, 2, 3)
            
        //deprecated
//        observableInts
//            .mapWithIndex { (e, i) -> Int in
//                return i == 1 ? e * 10 : e
//            }
//            .subscribe(onNext: { value in
//                print("mapWithIndex = \(value)")
//            })
//            .disposed(by: disposeBag)
    }
    
    func rxswiftScan() {
        let observableInts = Observable<Int>.of(1, 2, 3)
        
        observableInts.scan(0) { $0 + $1 }
            .subscribe(onNext: { value in
                print("scan = \(value)")
            })
            .disposed(by: disposeBag)
    }
    
    func rxswiftToArray() {
        let observableInts = Observable<Int>.of(1, 2, 3, 4)
        
        observableInts.toArray()
            .subscribe(onSuccess: { value in
                print("onSuccess = \(value)")
            })
            .disposed(by: disposeBag)
    }
}
