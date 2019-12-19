//
//  LoginViewModel.swift
//  RxSwift-Learning
//
//  Created by 고대원 on 2019/12/19.
//  Copyright © 2019 kodeawon. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift

class LoginViewModel {
    
    let emailText: BehaviorSubject<String> = BehaviorSubject(value: "")
    let passwordText: BehaviorSubject<String> = BehaviorSubject(value: "")
    
    let isEmailValid: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    let isPasswrodValid: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    
    init() {
        _ = emailText
            .distinctUntilChanged()
            .map(checkEmailValid(_:))
            .bind(to: isEmailValid)
        
        _ = passwordText
            .distinctUntilChanged()
            .map(checkPasswordValid(_:))
            .bind(to: isPasswrodValid)
    }
}

//MARK: - Vaild
extension LoginViewModel {
    private func checkEmailValid(_ email: String) -> Bool {
        return email.contains("@") && email.contains(".")
    }
    
    private func checkPasswordValid(_ password: String) -> Bool {
        return password.count > 4
    }
}
