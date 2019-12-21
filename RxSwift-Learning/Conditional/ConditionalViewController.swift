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

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Conditional"
    }

}

//MARK: - UITableViewDelegate
extension ConditionalViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

//MARK: - Rxswift
extension ConditionalViewController {
    func rxswiftAmb() {
        
    }
}
