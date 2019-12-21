//
//  ConditionalViewController.swift
//  RxSwift-Learning
//
//  Created by 고대원 on 2019/12/21.
//  Copyright © 2019 kodeawon. All rights reserved.
//

///Operators that evaluate one or more Observables or items emitted by Observables
///하나 이상의 Observable 또는 Observable이 방출 한 항목을 평가하는 연산자

import UIKit

import RxSwift

class ConditionalViewController: UITableViewController {
    
    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Conditional"
    }

}

//MARK: - UITableViewDelegate
extension ConditionalViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
            rxswiftAmb()
        case 1:
            rxswiftSkipUntil()
        case 2:
            rxswiftSkipWhile()
        case 3:
            rxswiftSkipWhileWithIndex()
        case 4:
            rxswiftTakeUntil()
        case 5:
            rxswiftTakeWhile()
        case 6:
            rxswiftTakeWhileWithIndex()
        default:
            break
        }
    }
}

//MARK: - Rxswift
extension ConditionalViewController {
    func rxswiftAmb() {
//        let observableNumbers = Observable<Int>.interval(.milliseconds(1 * 1000), scheduler: MainScheduler.instance)
        
        let observableNumbers = Observable<Int>.of(1, 2)
        
        let observable2Numbers = Observable<Int>.of(10, 20, 30)
        
        observableNumbers.amb(observable2Numbers)
            .subscribe(onNext: { value in
                print("amb = \(value)")
            })
            .disposed(by: disposeBag)
    }
    
    func rxswiftSkipUntil() {
        let observableNumbers = Observable<Int>.of(1, 2)
            .delay(.milliseconds(1 * 1000), scheduler: MainScheduler.instance)
        
        let observable2Numbers = Observable<Int>.of(10, 20, 30)
            .delay(.milliseconds(1 * 500), scheduler: MainScheduler.instance)
        
        observableNumbers.skipUntil(observable2Numbers)
            .subscribe(onNext: { value in
                print("skipUntil = \(value)")
            })
            .disposed(by: disposeBag)
    }
    
    func rxswiftSkipWhile() {
        let observableNumbers = Observable<Int>.of(1, 2, 3, 4, 5, 6)
        
        observableNumbers
            .skipWhile { (value) -> Bool in
                return value < 4
            }
            .subscribe(onNext: { value in
                print("skipWhile = \(value)")
                
            })
            .disposed(by: disposeBag)
    }
    
    func rxswiftSkipWhileWithIndex() {
        let observableNumbers = Observable<Int>.of(1, 2, 3, 4, 5, 6)
        
        ///deprecated
//        observableNumbers
//            .skipWhileWithIndex { (e, i) -> Bool in
//                print("skipWhileWithIndex{} e = \(e) i = \(i)")
//                return i < 4
//            }
//            .subscribe(onNext: { value in
//                print("skipWhileWithIndex = \(value)")
//
//            })
//            .disposed(by: disposeBag)
        
        ///대처
        observableNumbers
            .skipWhile { (value) -> Bool in
                return value < 4
            }
            .map { (value) -> Int in
                value
            }
            .subscribe(onNext: { value in
                print("skipWhileWithIndex = \(value)")
                
            })
            .disposed(by: disposeBag)
    }
    
    func rxswiftTakeUntil() {
        let observableNumbers = Observable<Int>.of(1, 2, 3, 4, 5, 6)
            .delay(.milliseconds(1 * 500), scheduler: MainScheduler.instance)
        
        let observable2Numbers = Observable<Int>.of(10, 20, 30)
            .delay(.milliseconds(1 * 501), scheduler: MainScheduler.instance)
        
        observableNumbers.takeUntil(observable2Numbers)
        .subscribe(onNext: { value in
            print("takeUntil onNext = \(value)")
        }, onError: { err in
            print("takeUntil onError = \(err)")
        }, onCompleted: {
            print("takeUntil onCompleted")
        })
        .disposed(by: disposeBag)
    }
    
    func rxswiftTakeWhile() {
        let observableNumbers = Observable<Int>.of(1, 2, 3, 4, 5, 6)
        
        observableNumbers
            .takeWhile { (value) -> Bool in
                return value < 4
            }
            .subscribe(onNext: { value in
                print("takeWhile onNext = \(value)")
            })
            .disposed(by: disposeBag)
    }
    
    func rxswiftTakeWhileWithIndex() {
        /// deprecated
        
        /// skip과 take의 차이는 onCompleted 시점이 다르다
        /// skip은 observable 스트림에 있는 데이터가 끝날때까지 하는것이고
        /// take는 조건이 맞지 않는 다음 시점 부터 onCompleted가 된다.
    }
}
