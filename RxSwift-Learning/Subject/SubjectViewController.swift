//
//  SubjectViewController.swift
//  RxSwift-Learning
//
//  Created by 고대원 on 2020/01/07.
//  Copyright © 2020 kodeawon. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

class SubjectViewController: UIViewController {
    
    var disposeBag = DisposeBag()
    
    // MARK: - properties
    var tikiViewController: TikiViewController?
    var takaViewController: TakaViewController?

    // MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Subject"
        
        bind()
    }
    
    // MARK: - segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier, identifier == "tiki" {
            tikiViewController = segue.destination as? TikiViewController
        }else if let identifier = segue.identifier, identifier == "taka" {
            takaViewController = segue.destination as? TakaViewController
        }
    }
}

// MARK: - bind
extension SubjectViewController {
    func bind() {
        guard let tikiVC = tikiViewController,
        let takaVC = takaViewController else {
            return
        }
        
        takaVC.viewModel.output
            .bind(to: tikiVC.outputTextView.rx.text)
            .disposed(by: disposeBag)
        
        tikiVC.viewModel.output
            .bind(to: takaVC.outputTextView.rx.text)
            .disposed(by: disposeBag)
    
    }
}
