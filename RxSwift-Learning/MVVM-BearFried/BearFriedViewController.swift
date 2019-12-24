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
        
        viewModel.allMenus
            .bind(to: tableView.rx.items(cellIdentifier: BearFriedTableViewCell.identifier,
                                         cellType: BearFriedTableViewCell.self))
            { _, item, cell in
                cell.nameLabel.text = "1"
            }
            .disposed(by: disposeBag)

        viewModel.totalCountText
            .bind(to: itemsCountLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.totalPriceText
            .bind(to: totalPriceLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
