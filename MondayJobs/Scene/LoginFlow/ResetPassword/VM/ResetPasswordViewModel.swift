//
//  ResetPasswordViewModel.swift
//  MondayJobs
//
//  Created by Ashkan Ghaderi on 11/1/20.
//  Copyright © 2020 Elinium. All rights reserved.
//

import Foundation
import Domain
import RxCocoa
import RxSwift

final class ResetPasswordViewModel: ViewModelType {
    
    private let navigator: ResetPasswordNavigator
    private let useCase: Domain.AuthenticationUseCase
    private var email : String
    
    init( navigator: ResetPasswordNavigator, useCase: Domain.AuthenticationUseCase,email: String) {
        self.useCase = useCase
        self.navigator = navigator
        self.email = email
    }
    
    func transform(input: Input) -> Output {
        let activityIndicator = ActivityIndicator()
        let errorTracker = ErrorTracker()
        
        let canReset = Driver.combineLatest(input.password, input.rePassword){ (pass, rePass) in
            return !pass.isEmpty && !rePass.isEmpty && pass == rePass
        }
        
        let reset = input.resetTrigger.withLatestFrom(input.password)
            .map { (pass) -> ResetPasswordModel.Request in
                return ResetPasswordModel.Request(email: self.email, password: pass)
        }
        .flatMapLatest { [unowned self] in
            return self.useCase.resetPassword(request: $0)
                .trackActivity(activityIndicator).trackError(errorTracker).do(onNext: { [unowned self](respose) in
                    
                    
                    })
                .asDriverOnErrorJustComplete().mapToVoid()
        }
        
        
        
        
        let rePasswordCorrect = Driver<String>.combineLatest(input.password, input.rePassword){ (pass, rePass) in
            
            if pass == rePass {
                return NSLocalizedString("pass_rePass_notMatch", comment: "")
            }
            return ""
        }
        
        
        
        
        let passCorrect = input.password.map { (pass) -> [[String: String]] in
            if pass != "" || !pass.isEmpty {
                var resultList : [[String: String]] = [["": ""],["": ""],["": ""],["": ""]]
                let numbersRange = pass.rangeOfCharacter(from: .decimalDigits)
                if numbersRange != nil {
                    let dict = [NSLocalizedString("pass_has_digits", comment: "") : "true"]
                    resultList[0] = dict
                } else {
                    let dict = [NSLocalizedString("pass_has_digits", comment: "") : "false"]
                    resultList[0] = dict
                }
                
                if  !pass.isEmpty && pass != "" {
                    if pass.count < 8 {
                        let dict = [NSLocalizedString("pass_count_8", comment: "") : "false"]
                        resultList[1] = dict
                    } else if pass.count >= 8 {
                        let dict = [NSLocalizedString("pass_count_8", comment: "") : "true"]
                        resultList[1] = dict
                    }
                }
                
                let capitalLetterRegEx  = ".*[A-Z]+.*"
                let texttest = NSPredicate(format:"SELF MATCHES %@", capitalLetterRegEx)
                if texttest.evaluate(with: pass) {
                    let dict = [NSLocalizedString("pass_has_capital", comment: "") : "true"]
                    resultList[2] = dict
                } else {
                    let dict = [NSLocalizedString("pass_has_capital", comment: "") : "false"]
                    resultList[2] = dict
                }
                
                let specialCharacterRegEx  = ".*[!&^%$#@()/]+.*"
                let texttest2 = NSPredicate(format:"SELF MATCHES %@", specialCharacterRegEx)
                if texttest2.evaluate(with: pass) {
                    let dict = [NSLocalizedString("pass_has_special", comment: "") : "true"]
                    resultList[3] = dict
                } else {
                    let dict = [NSLocalizedString("pass_has_special", comment: "") : "false"]
                    resultList[3] = dict
                }
                
                return resultList
            } else {
                return [[:]]
            }
        }
        
        
        let cancelAction = input.cancelTrigger.do(onNext: { [unowned self]() in
            self.navigator.toLogin()
        }).mapToVoid()
        
        
        
        let fetching = activityIndicator.asDriver()
        let errors = errorTracker.asDriver()
        return Output(resetAction: reset, cancelAction: cancelAction, canReset: canReset, rePasswordError: rePasswordCorrect, passwordError: passCorrect, error: errors, isFetching: fetching)
    }
    
}

extension ResetPasswordViewModel {
    struct Input {
        let resetTrigger: Driver<Void>
        let cancelTrigger: Driver<Void>
        let password: Driver<String>
        let rePassword: Driver<String>
    }
    
    struct Output {
        let resetAction: Driver<Void>
        let cancelAction: Driver<Void>
        let canReset: Driver<Bool>
        let rePasswordError: Driver<String>
        let passwordError: Driver<[[String: String]]>
        let error: Driver<Error>
        let isFetching: Driver<Bool>
        
    }
    
}
