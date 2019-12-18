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

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Login"
        
        bindUI()
    }
    
    //MARK: Actions
    @IBAction func loginDidTap(_ sender: UIButton) {
        sender.isSelected ? print("\(#function) Login") : print("\(#function) Fill the Fields")
    }

    //MARK: Bind UI
    private func bindUI() {
        emailTextField.rx.text.orEmpty
            .map{ self.checkEmailValid($0) }
            .distinctUntilChanged()
            .subscribe(onNext: { (bool) in
                print("\(#function) checkEmailValid = \(bool)")
                self.emailValidView.isHidden = bool
            }, onError: { (err) in
                print("\(#function) err = \(err)")
            }, onCompleted: {
                print("\(#function) onCompleted")
            }, onDisposed: {
                print("\(#function) onDisposed")
            })
            .disposed(by: disposeBag)
        
        pwTextField.rx.text.orEmpty
            .map{ self.checkPasswordValid($0) }
            .distinctUntilChanged()
            .subscribe(onNext: { (bool) in
                print("\(#function) checkPasswordValid = \(bool)")
                self.pwValidView.isHidden = bool
            }, onError: { (err) in
                print("\(#function) err = \(err)")
            }, onCompleted: {
                print("\(#function) onCompleted")
            }, onDisposed: {
                print("\(#function) onDisposed")
            })
            .disposed(by: disposeBag)
        
        Observable.combineLatest(
            emailTextField.rx.text.orEmpty.map{ self.checkEmailValid($0) },
            pwTextField.rx.text.orEmpty.map{ self.checkPasswordValid($0) },
            resultSelector: { (s1: Bool, s2: Bool) in
                return s1 && s2
            })
            .subscribe(onNext: { (bool) in
                self.loginButton.isSelected = bool
            })
            .disposed(by: disposeBag)
    }
}

//MARK: - Vaild
extension LoginViewController {
    private func checkEmailValid(_ email: String) -> Bool {
        return email.contains("@") && email.contains(".")
    }
    
    private func checkPasswordValid(_ password: String) -> Bool {
        return password.count > 4
    }
}
