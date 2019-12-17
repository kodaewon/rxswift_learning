//
//  BasicViewController.swift
//  RxSwift-Learning
//
//  Created by 고대원 on 2019/12/17.
//  Copyright © 2019 kodeawon. All rights reserved.
//

import UIKit

import RxSwift

class BasicViewController: UITableViewController {
    
    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Creating"
    }

    override func viewWillDisappear(_ animated: Bool) {
        disposeBag = DisposeBag()
    }
}

//MARK: - UITableViewDelegate
extension BasicViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            rxswiftJust()
        case 1:
            rxswiftFrom()
        case 2:
            rxswiftInterval()
        case 3:
            rxswiftRange()
        case 4:
            rxswiftCreate()
        case 5:
            rxswiftGenerate()
        case 6:
            rxswiftDefer()
        default:
            break
        }
    }
}

//MARK: - RxSwift
extension BasicViewController {
    func rxswiftCreate() {
        Observable<Int>.create { observer in
            for i in 0...4 {
                observer.onNext(i)
            }
            observer.onCompleted()
            
            return Disposables.create()
        }
        .subscribe(onNext: { (value) in
            print("\(#function) next = \(value)")
        }, onError: { (err) in
            print("\(#function) err = \(err)")
        }, onCompleted: {
            print("\(#function) onCompleted")
        }, onDisposed: {
            print("\(#function) onDisposed")
        })
        .disposed(by: disposeBag)
    }
    
    func rxswiftGenerate() {
        Observable.generate(
            initialState: 0,
            condition: { $0 < 3 },
            iterate: { $0 + 1 }
        )
        .subscribe(onNext: { (value) in
            print("\(#function) next = \(value)")
        }, onError: { (err) in
            print("\(#function) err = \(err)")
        }, onCompleted: {
            print("\(#function) onCompleted")
        }, onDisposed: {
            print("\(#function) onDisposed")
        })
        .disposed(by: disposeBag)
    }
    
    func rxswiftJust() {
        Observable.just("1")
            .subscribe({ next in
                switch next {
                case .next(let string):
                    print("\(#function) next = \(string)")
                case .completed:
                    print("\(#function) completed")
                default:
                    break
                }
            })
        .disposed(by: disposeBag)
    }
    
    func rxswiftFrom() {
        Observable.from(["a", "b", 1])
            .subscribe({ next in
                switch next {
                case .next(let value):
                    print("\(#function) next = \(value)")
                case .completed:
                    print("\(#function) completed")
                default:
                    break
                }
            })
        .disposed(by: disposeBag)
    }
    
    func rxswiftInterval() {
        Observable<Int>.interval(.milliseconds(1 * 500), scheduler: MainScheduler.instance)
            .take(2)
            .subscribe(onNext: { (value) in
                print("\(#function) next = \(value)")
            }, onError: { (err) in
                print("\(#function) err = \(err)")
            }, onCompleted: {
                print("\(#function) onCompleted")
            }, onDisposed: {
                print("\(#function) onDisposed")
            })
        .disposed(by: disposeBag)
    }
    
    func rxswiftRange() {
        Observable.range(start: 1, count: 2)
            .subscribe(onNext: { (value) in
                print("\(#function) next = \(value)")
            }, onError: { (err) in
                print("\(#function) err = \(err)")
            }, onCompleted: {
                print("\(#function) onCompleted")
            }) {
                print("\(#function) onDisposed")
        }.disposed(by: disposeBag)
    }
    
    func rxswiftDefer() {
        var count = 0
        
        let deferredSequence = Observable<Int>.deferred {
            count += 1
            return Observable.create { observer in
                observer.onNext(count)
                observer.onCompleted()
                return Disposables.create()
            }
        }
        
        deferredSequence
            .subscribe(onNext: { (value) in
                print("\(#function) next = \(value)")
            }, onError: { (err) in
                print("\(#function) err = \(err)")
            }, onCompleted: {
                print("\(#function) onCompleted")
            }) {
                print("\(#function) onDisposed")
        }
        .disposed(by: disposeBag)
        
        deferredSequence
            .subscribe(onNext: { (value) in
                print("\(#function) next = \(value)")
            }, onError: { (err) in
                print("\(#function) err = \(err)")
            }, onCompleted: {
                print("\(#function) onCompleted")
            }) {
                print("\(#function) onDisposed")
        }
        .disposed(by: disposeBag)
    }
}
