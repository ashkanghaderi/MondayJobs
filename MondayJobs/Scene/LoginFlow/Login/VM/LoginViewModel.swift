//
//  LoginViewModel.swift
//  MondayJobs
//
//  Created by Ashkan Ghaderi on 10/31/20.
//  Copyright © 2020 Elinium. All rights reserved.
//

import Foundation
import Domain
import RxCocoa
import RxSwift
import NetworkPlatform

final class LoginViewModel: ViewModelType {
    
    private let navigator: LoginNavigator
    private let useCase: Domain.AuthenticationUseCase
    
    init( navigator: LoginNavigator, useCase: Domain.AuthenticationUseCase) {
        self.useCase = useCase
        self.navigator = navigator
    }
    
    func transform(input: Input) -> Output {
        let activityIndicator = ActivityIndicator()
        let errorTracker = ErrorTracker()
        var error : Driver<Error>?
        
        
        let loginStaff = Driver.combineLatest(input.email, input.password)
        
        let canLogin = Driver.combineLatest(input.email, input.password){ (email, pass) in
            return !email.isEmpty && !pass.isEmpty
        }
        
        let emailCorrect = input.email.map { (email) -> String in
            if email != "" {
                if !email.isValidEmail(){
                    return NSLocalizedString("provide_email", comment: "")
                }
            }
            return  ""
        }
        
        let  canReset = Driver.combineLatest(input.email, emailCorrect){ (email, emailError) in
            return !email.isEmpty && emailError == ""
        }
        
        let login = input.loginTrigger.withLatestFrom(loginStaff)
            .map { (email, pass) -> LoginModel.Request in
                return LoginModel.Request(email: email, password: pass)
        }
        .flatMapLatest { [unowned self] in
            return self.useCase.login(request: $0)
                .trackActivity(activityIndicator).trackError(errorTracker).do(onNext: { [unowned self](respose) in
                    AuthorizationInfo.saveData(data: respose)
                    self.navigator.toHome()
                    
                    },onError: {(error) in
                            print(error)
                    })
                .asDriverOnErrorJustComplete().mapToVoid()
        }
        
        let forgot = input.forgotPassTrigger.withLatestFrom(loginStaff)
            .map { (email, pass) -> RequestResetModel.Request in
                return RequestResetModel.Request(email: email, password: pass)
        }
        .flatMapLatest { [unowned self] in
            return self.useCase.requestReset(request: $0)
                .trackActivity(activityIndicator).trackError(errorTracker).do(onNext: { [unowned self](respose) in
                    if let email = respose.email {
                        self.navigator.toResetPassword(email: email)
                    }
                    })
                .asDriverOnErrorJustComplete().mapToVoid()
        }
        
        
        
        
        let backAction = input.backTrigger.do(onNext: { [unowned self]() in
            self.navigator.Back()
        }).mapToVoid()
        
        let fetching = activityIndicator.asDriver()
        let errors = errorTracker.asDriver()
        
        return Output(loginAction: login, forgotPassAction: forgot, backAction: backAction, canLogin: canLogin, canReset: canReset,emailError: emailCorrect, error: errors, isFetching: fetching)
    }
    
}

extension LoginViewModel {
    struct Input {
        
        let loginTrigger: Driver<Void>
        let forgotPassTrigger: Driver<Void>
        let backTrigger: Driver<Void>
        let email: Driver<String>
        let password: Driver<String>
    }
    
    struct Output {
        let loginAction: Driver<Void>
        let forgotPassAction: Driver<Void>
        let backAction: Driver<Void>
        let canLogin: Driver<Bool>
        let canReset: Driver<Bool>
        let emailError: Driver<String>
        let error: Driver<Error>
        let isFetching: Driver<Bool>
        
    }
    
}

