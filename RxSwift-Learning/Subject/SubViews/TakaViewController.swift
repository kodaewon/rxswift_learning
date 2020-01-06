//
//  TakaViewController.swift
//  RxSwift-Learning
//
//  Created by 고대원 on 2020/01/07.
//  Copyright © 2020 kodeawon. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

class TakaViewController: UIViewController {
    
    var disposeBag = DisposeBag()
    
    // MARK: - iboutlet properties
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var outputTextView: UITextView!
    
    // MARK: - properties
    var viewModel: TikiTakaProtocol
    
    // MARK: - init
    init(viewModel: TikiTakaProtocol = TakaViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.viewModel = TakaViewModel()
        super.init(coder: coder)
    }
    
    // MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        bind()
    }
}

//MARK: - bind
extension TakaViewController {
    func bind() {
        inputTextField.rx.text.orEmpty
            .bind(to: viewModel.intput)
            .disposed(by: disposeBag)
        
        viewModel.intput
            .bind(to: inputTextField.rx.text)
            .disposed(by: disposeBag)
        
        sendButton.rx.tap
            .asControlEvent()
            .bind(to: viewModel.send)
            .disposed(by: disposeBag)
        
        viewModel.error
            .subscribe(onNext: { err in
                print("error = \(err)")
            })
            .disposed(by: disposeBag)
    }
}
