//
//  BearFriedTableViewCell.swift
//  RxSwift-Learning
//
//  Created by 고대원 on 2019/12/24.
//  Copyright © 2019 kodeawon. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

class BearFriedTableViewCell: UITableViewCell {
    
    static let identifier = "BearFriedTableViewCell"
    
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    var disposeBag = DisposeBag()
    private let onCountChanged: (Int) -> Void
    private let cellDisposeBag = DisposeBag()
    
    let onData: AnyObserver<MenuModel>
    let onIncrease: Observable<Int>
    
    required init?(coder: NSCoder) {
        let data = PublishSubject<MenuModel>()
        let inc = PublishSubject<Int>()
        onCountChanged = { inc.onNext($0) }
        
        onData = data.asObserver()
        onIncrease = inc.asObserver()

        super.init(coder: coder)
        
        /// cellDisposeBag 사용하는 이유는 cell별로 bag이 필요한다
        /// 그런데 ViewController에서 Cell에 대한 개별 bag이 필요해서
        /// 초기화를 하고 있는 bag이 필요하므로 나눠었다.
        data.subscribeOn(MainScheduler.instance)
            .subscribe(onNext: {  [weak self] item in
                self?.nameLabel.text = item.name
                self?.priceLabel.text = item.price.currencyString(.kr)
                self?.countLabel.text = "\(item.count)"
            })
            .disposed(by: cellDisposeBag)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    @IBAction func onIncreaseCount() {
        onCountChanged(1)
    }

    @IBAction func onDecreaseCount() {
        onCountChanged(-1)
    }
}
