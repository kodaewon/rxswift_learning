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
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        bindUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    //MARK: Bind UI
    func bindUI() {
        
    }
}
