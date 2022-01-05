//
//  FilteringViewController.swift
//  RxSwift-Learning
//
//  Created by 고대원 on 2019/12/22.
//  Copyright © 2019 kodeawon. All rights reserved.
//

import UIKit

import RxSwift

class FilteringViewController: UITableViewController {
    
    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Filtering"
    }
}

//MARK: - UITableViewDelegate
extension FilteringViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            rxswiftDebounce()
        case 1:
            rxswiftDistinctUntilChanged()
        case 2:
            rxswiftElementAt()
        case 3:
            rxswiftFilter()
        case 4:
            rxswiftIgnoreElements()
        case 5:
            rxswiftSample()
        case 6:
            rxswiftSingle()
        case 7:
            rxswiftSkip()
        case 8:
            rxswiftSkipDuration()
        case 9:
            rxswiftTake()
        case 10:
            rxswifttakeDuration()
        case 11:
            rxswiftTakeLast()
        case 12:
            rxswiftThrottle()
        default:
            break
        }
    }
}

//MARK: - rxswift
extension FilteringViewController {
    func rxswiftDebounce() {
        let observableInts = Observable<Int>.of(1, 2, 3)
        
        observableInts.debounce(.milliseconds(1 * 500), scheduler: MainScheduler.instance)
            .subscribe(onNext: { value in
                print("debounce = \(value)")
            })
            .disposed(by: disposeBag)
    }
    
    func rxswiftDistinctUntilChanged() {
        let observableBools = Observable<Bool>.of(false, true, true, false)
        
        observableBools
            .distinctUntilChanged()
            .subscribe(onNext: { value in
                print("distinctUntilChanged = \(value)")
            })
            .disposed(by: disposeBag)
        
    }
    
    func rxswiftElementAt() {
        let observableInts = Observable<Int>.of(1, 2, 3, 4, 5, 6)
        
        observableInts.elementAt(4)
            .subscribe(onNext: { value in
                print("elementAt = \(value)")
            })
            .disposed(by: disposeBag)
    }
    
    func rxswiftFilter() {
        let observableInts = Observable<Int>.of(1, 11, 22, 3, 50)
        
        observableInts.filter{ $0 > 20 }
            .subscribe(onNext: { value in
                print("filter = \(value)")
            })
            .disposed(by: disposeBag)
    }
    
    func rxswiftIgnoreElements() {
        let observableInts = Observable<Int>.of(1, 2, 3, 4, 5, 6)
//        
//        observableInts.ignoreElements()
//            .subscribe(onCompleted: {
//                print("ignoreElements = onCompleted")
//            }, onError: { err in
//                print("ignoreElements err = \(err)")
//            })
//            .disposed(by: disposeBag)
//        
//        observableInts.ignoreElements()
    }
    
    func rxswiftSample() {
        let observableInts = Observable<Int>.of(1, 2, 3, 4, 5, 6)
        
        let observableStrings = Observable<String>.of("a", "b", "c")
        
        observableInts.sample(observableStrings)
            .subscribe(onNext: { value in
                print("sample = \(value)")
            })
            .disposed(by: disposeBag)
    }
    
    func rxswiftSingle() {
        let observableInts = Observable<Int>.of(1, 2, 3, 4, 5, 6)
        
        observableInts.single()
            .subscribe(onNext: { value in
                print("single = \(value)")
            })
            .disposed(by: disposeBag)
    }
    
    func rxswiftSkip() {
        let observableInts = Observable<Int>.of(1, 2, 3, 4, 5, 6)
        
        observableInts.skip(3)
            .subscribe(onNext: { value in
                print("skip = \(value)")
            })
            .disposed(by: disposeBag)
    }
    
    func rxswiftSkipDuration() {
        let observableInts = Observable<Int>.of(1, 2, 3, 4, 5, 6)
        
        observableInts
            .delay(.milliseconds(1 * 100), scheduler: MainScheduler.instance)
            .skip(.milliseconds(1 * 101), scheduler: MainScheduler.instance)
            .subscribe(onNext: { value in
                print("rxswiftSkipDuration = \(value)")
            })
            .disposed(by: disposeBag)
    }
    
    func rxswiftTake() {
        let observableInts = Observable<Int>.of(1, 2, 3, 4, 5, 6)
        
        observableInts.take(1)
        .subscribe(onNext: { value in
            print("take = \(value)")
        })
        .disposed(by: disposeBag)
    }
    
    func rxswifttakeDuration() {
        let observableInts = Observable<Int>.of(1, 2, 3, 4, 5, 6)
        
        observableInts
            .take(.milliseconds(1 * 101), scheduler: MainScheduler.instance)
            .subscribe(onNext: { value in
                print("rxswifttakeDuration = \(value)")
            })
            .disposed(by: disposeBag)
    }
    
    func rxswiftTakeLast() {
        let observableInts = Observable<Int>.of(1, 2, 3, 4, 5, 6)
        
        observableInts
            .takeLast(2)
            .subscribe(onNext: { value in
                print("takeLast = \(value)")
            })
            .disposed(by: disposeBag)
    }
    
    func rxswiftThrottle() {
        let observableInts = Observable<Int>.of(1, 2, 3, 4, 5, 6)
        
        observableInts.throttle(.milliseconds(1 * 100), scheduler: MainScheduler.instance)
            .subscribe(onNext: { value in
                print("throttle = \(value)")
            })
            .disposed(by: disposeBag)
    }
}
