//
//  MathematicalViewController.swift
//  RxSwift-Learning
//
//  Created by 고대원 on 2019/12/23.
//  Copyright © 2019 kodeawon. All rights reserved.
//

import UIKit

import RxSwift

class MathematicalViewController: UITableViewController {
    
    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Mathematical"
    }

}

//MARK: - UITableViewDelegate
extension MathematicalViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            rxswiftReduce()
        default:
            break
        }
    }
}

//MARK: - Rxswift
extension MathematicalViewController {
    func rxswiftReduce() {
        let observableInts = Observable<Int>.of(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
        
        observableInts
            .reduce(0) { $0 + $1 }
            .subscribe(onNext: { value in
                print("reduce = \(value)")
            })
            .disposed(by: disposeBag)
    }
}
