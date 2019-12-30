//
//  BearFriedViewController.swift
//  RxSwift-Learning
//
//  Created by 고대원 on 2019/12/24.
//  Copyright © 2019 kodeawon. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa
import RxViewController

class BearFriedViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var itemsCountLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var orderButton: UIButton!
    
    var disposeBag = DisposeBag()
    
    let viewModel: BearFriedViewModelType
    
    init(viewModel: BearFriedViewModelType = BearFriedViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        viewModel = BearFriedViewModel()
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        setupBindings()
    }
    
    func setupUI() {
        self.navigationItem.title = "Bear Fried"
        
        tableView.refreshControl = UIRefreshControl()
    }
    
    func setupBindings() {
        let firstLoad = rx.viewWillAppear
            .take(1)
            .map { _ in () }
        
        let reload = tableView.refreshControl?.rx
            .controlEvent(.valueChanged)
            .map { _ in () } ?? Observable.just(())

        Observable.merge([firstLoad, reload])
            .bind(to: viewModel.fetchMenus)
            .disposed(by: disposeBag)
        
        /// TableView에 데이터 반영
        viewModel.allMenus
            .bind(to: tableView.rx.items(cellIdentifier: BearFriedTableViewCell.identifier,
                                         cellType: BearFriedTableViewCell.self))
            { _, item, cell in
                cell.onData.onNext(item)
                cell.onIncrease
                    .map { (item, $0) }
                    .bind(to: self.viewModel.increaseMenuCount)
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
        
        viewModel.actived
            .subscribe(onNext: { activied in
                if activied {
                    self.tableView.refreshControl?.endRefreshing()
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.totalCountText
            .bind(to: itemsCountLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.totalPriceText
            .bind(to: totalPriceLabel.rx.text)
            .disposed(by: disposeBag)
        
        clearButton.rx.tap
            .asControlEvent()
            .bind(to: self.viewModel.clearMenus)
            .disposed(by: disposeBag)
        
        orderButton.rx.tap
            .asControlEvent()
            .bind(to: self.viewModel.orderMenus)
            .disposed(by: disposeBag)
    }
}

//MARK: - Int Extesion
extension Int {
    enum CurrencyStyle {
        case kr, en
        
        var value: String {
            switch self {
            case .kr:
                return "ko_KR"
            case .en:
                return "en"
            }
        }
    }
    
    func currencyString(_ style: CurrencyStyle) -> String {
        let numberFormat = NumberFormatter()
        numberFormat.numberStyle = .currency
        numberFormat.locale = Locale(identifier: style.value)
        return numberFormat.string(from: NSNumber(value: self)) ?? "0"
    }
}
