//
//  LoginViewController.swift
//  RxSwift-Learning
//
//  Created by 고대원 on 2019/12/18.
//  Copyright © 2019 kodeawon. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var pwTextField: UITextField!
    @IBOutlet weak var emailValidView: UIView!
    @IBOutlet weak var pwValidView: UIView!
    @IBOutlet weak var loginButton: UIButton!
    
    var disposeBag = DisposeBag()
    
    let loginViewModel = LoginViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Login"
        
        bindUI()
        
        bindAction()
    }
    
    //MARK: Bind Action
    private func bindAction() {
        loginButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.loginButton.isSelected ? print("\(#function) Login") : print("\(#function) Fill the Fields")
            })
            .disposed(by: disposeBag)
    }

    //MARK: Bind UI
    private func bindUI() {
        emailTextField.rx.text.orEmpty
            .bind(to: loginViewModel.emailText)
            .disposed(by: disposeBag)
        
        pwTextField.rx.text.orEmpty
            .bind(to: loginViewModel.passwordText)
            .disposed(by: disposeBag)
        
        loginViewModel.isEmailValid
            .bind(to: emailValidView.rx.isHidden)
            .disposed(by: disposeBag)
        
        loginViewModel.isPasswrodValid
            .bind(to: pwValidView.rx.isHidden)
            .disposed(by: disposeBag)
        
//        Observable.combineLatest(
//            loginViewModel.isEmailValid,
//            loginViewModel.isPasswrodValid,
//            resultSelector: { (s1: Bool, s2: Bool) in
//                return s1 && s2
//            })
//            .bind(to: loginButton.rx.isSelected)
//            .disposed(by: disposeBag)
        
        Observable.combineLatest(loginViewModel.isEmailValid, loginViewModel.isPasswrodValid) { $0 && $1 }
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { bool in
                self.loginButton.isSelected = bool
            })
            .disposed(by: disposeBag)
    }
}
