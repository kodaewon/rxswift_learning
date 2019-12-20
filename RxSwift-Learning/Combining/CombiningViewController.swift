//
//  CombiningViewController.swift
//  RxSwift-Learning
//
//  Created by 고대원 on 2019/12/19.
//  Copyright © 2019 kodeawon. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift

class CombiningViewController: UITableViewController {
    
    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Combining"
    }
}

//MARK: - UITableViewDelegate
extension CombiningViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            rxswiftCombining()
        case 1:
            rxswiftConCat()
        case 2:
            rxswiftMerge()
        case 3:
            rxswiftStartWith()
        case 4:
            rxswiftSwitchLatest()
        case 5:
            rxswiftWithLatestFrom()
        case 6:
            rxswiftZip()
        default:
            break
        }
    }
}

//MARK: Rxswift
extension CombiningViewController {
    func rxswiftCombining() {
        let observableJust = Observable<String>.just("1")
        
        observableJust
            .subscribe(onNext: { value in
                print("observableJust = \(value)")
            })
            .disposed(by: disposeBag)
            
        
        // delay 와 interval에 차이를 알 수 있습니다.
        
        let observableFrom = Observable<Int>.interval((.milliseconds(1 * 100)), scheduler: MainScheduler.instance)
            
        observableFrom
            .take(3)
            .subscribe(onNext: { (value) in
                print("observableFrom = \(value)")
            })
            .disposed(by: disposeBag)
        
//        let observableFrom = Observable<String>.from(["a", "b", "c"])
//
//        observableFrom
//            .delay(.milliseconds(1 * 1000), scheduler: MainScheduler.instance)
//            .do(onNext: { value in
//                print("do observableFrom = \(value)")
//            })
//            .subscribe(onNext: { value in
//                print("observableFrom = \(value)")
//            })
//            .disposed(by: disposeBag)
        
        Observable.combineLatest(observableJust, observableFrom) { $0 + "\($1)" }
            .subscribe(onNext: { value in
                print("combineLatest = \(value)")
            })
            .disposed(by: disposeBag)
    }
    
    func rxswiftConCat() {
        let observableFromNumbers = Observable<String>.from(["1", "2", "3"])
        
        observableFromNumbers
            .subscribe(onNext: { value in
                print("observableFromNumbers = \(value)")
            })
            .disposed(by: disposeBag)
        
        let observableFromAlphabet = Observable<String>.from(["a", "b"])
        
        observableFromAlphabet
            .subscribe(onNext: { value in
                print("observableFromAlphabet = \(value)")
            })
            .disposed(by: disposeBag)
        
        Observable.concat([observableFromNumbers, observableFromAlphabet])
            .subscribe(onNext: { value in
                print("Observable.concat = \(value)")
            })
            .disposed(by: disposeBag)
    }
    
    func rxswiftMerge() {
        let observableOfNumbers = Observable<String>.of("1", "2")
        
        let observableOfAlphabet = Observable<String>.of("a", "b", "c")
        
        Observable.of(observableOfNumbers, observableOfAlphabet)
            .merge()
            .subscribe(onNext: { value in
                print("Observable merge = \(value)")
            })
            .disposed(by: disposeBag)
    }
    
    func rxswiftStartWith() {
        let observableOfNumbers = Observable<String>.of("2", "3")
        
        observableOfNumbers.startWith("1")
            .subscribe(onNext: { value in
                print("startWith = \(value)")
            })
            .disposed(by: disposeBag)
    }
    
    func rxswiftSwitchLatest() {
        let observableOfNumbers = Observable<String>.of("1", "2", "3")
        
        observableOfNumbers
            .subscribe(onNext: { value in
                print("observableOfNumbers = \(value)")
            })
            .disposed(by: disposeBag)
        
        let observableOfAlphabet = Observable<String>.of("a", "b")
        
        observableOfAlphabet
                   .subscribe(onNext: { value in
                       print("observableOfAlphabet = \(value)")
                   })
                   .disposed(by: disposeBag)
        
        Observable.of(observableOfNumbers, observableOfAlphabet)
            .switchLatest()
            .subscribe(onNext: { value in
                print("switchLatest = \(value)")
            })
            .disposed(by: disposeBag)
    }
    
    func rxswiftWithLatestFrom() {
        let observableOfNumbers = Observable<String>.of("1", "2", "3")
        
        observableOfNumbers
            .subscribe(onNext: { value in
                print("observableOfNumbers = \(value)")
            })
            .disposed(by: disposeBag)
        
        let observableOfAlphabet = Observable<String>.of("a", "b")
        
        observableOfAlphabet
                   .subscribe(onNext: { value in
                       print("observableOfAlphabet = \(value)")
                   })
                   .disposed(by: disposeBag)
        
        observableOfNumbers.withLatestFrom(observableOfAlphabet)
            .subscribe(onNext: { value in
                print("withLatestFrom = \(value)")
            })
            .disposed(by: disposeBag)
    }
    
    func rxswiftZip() {
        let observableOfNumbers = Observable<String>.of("1", "2", "3")
        
        observableOfNumbers
            .subscribe(onNext: { value in
                print("observableOfNumbers = \(value)")
            })
            .disposed(by: disposeBag)
        
        let observableOfAlphabet = Observable<String>.of("a", "b")
        
        observableOfAlphabet
                   .subscribe(onNext: { value in
                       print("observableOfAlphabet = \(value)")
                   })
                   .disposed(by: disposeBag)
        
        Observable.zip(observableOfNumbers, observableOfAlphabet) { $0 + $1 }
            .subscribe(onNext: { value in
                print("zip = \(value)")
            })
            .disposed(by: disposeBag)
    }
}
