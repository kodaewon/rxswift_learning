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
}
