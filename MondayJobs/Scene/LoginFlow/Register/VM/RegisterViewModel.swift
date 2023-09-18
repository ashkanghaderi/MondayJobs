//
//  RegisterViewModel.swift
//  MondayJobs
//
//  Created by Ashkan Ghaderi on 10/21/20.
//  Copyright © 2020 Elinium. All rights reserved.
//

import Foundation
import Domain
import RxCocoa
import RxSwift
import NetworkPlatform

final class RegisterViewModel: ViewModelType {
    
    private let navigator: RegisterNavigator
    private let useCase: Domain.AuthenticationUseCase
    
    init( navigator: RegisterNavigator, useCase: Domain.AuthenticationUseCase) {
        self.useCase = useCase
        self.navigator = navigator
    }
    
    func transform(input: Input) -> Output {
        let activityIndicator = ActivityIndicator()
        let errorTracker = ErrorTracker()
        
        let workPermit = input.workPermitTrigger.scan(false) { editing, _ in
            return !editing
        }.startWith(false)
        
        let tas = input.TASTrigger.scan(false) { editing, _ in
            return !editing
        }.startWith(false)
        
        let registerStaff = Driver.combineLatest(input.name, input.job, input.email, input.password, workPermit , tas)
        
        let canRegister = Driver.combineLatest(input.name, input.job, input.email, input.password, workPermit , tas){ (name, job, email, pass, wPermit, tas) in
            return !name.isEmpty && !job.isEmpty && !email.isEmpty && !pass.isEmpty && wPermit && tas
        }
        
        let register = input.registerTrigger.withLatestFrom(registerStaff)
            .map { (name, job, email, pass, wPermit, tas) -> AttendeeRegisterModel.Request in
                return AttendeeRegisterModel.Request(name: name,email: email, password: pass, job: job, hasWorkPermit: wPermit, tos: tas)
        }
        .flatMapLatest { [unowned self] in
            return self.useCase.RegisterUser(request: $0)
                .trackActivity(activityIndicator).trackError(errorTracker).do(onNext: { [unowned self](response) in
                    
                    AuthorizationInfo.saveData(data: response)
                    self.navigator.toConfirm()
                    })
                .asDriverOnErrorJustComplete().mapToVoid()
        }
        
        let nameCorrect = input.name.map { (name) -> String in
            
            let specialCharacterRegEx  = ".*[!&^%$#@()/]+.*"
            let texttest = NSPredicate(format:"SELF MATCHES %@", specialCharacterRegEx)
            if texttest.evaluate(with: name) {
                return NSLocalizedString("name_Invalid", comment: "")
            }
            
            let numbersRange = name.rangeOfCharacter(from: .decimalDigits)
            if numbersRange != nil {
                return NSLocalizedString("name_Invalid", comment: "")
            }
            
            return ""
        }
        
        let emailCorrect = input.email.map { (email) -> String in
            if email != "" {
                if !email.isValidEmail(){
                    return NSLocalizedString("provide_email", comment: "")
                }
            }
            return  ""
        }
        
        let jobCorrect = input.job.map { (job) -> String in
            
            let specialCharacterRegEx  = ".*[!&^%$#@()/]+.*"
            let texttest = NSPredicate(format:"SELF MATCHES %@", specialCharacterRegEx)
            if texttest.evaluate(with: job) {
                return NSLocalizedString("provide_jobTitle", comment: "")
            }
            
            let numbersRange = job.rangeOfCharacter(from: .decimalDigits)
            if numbersRange != nil {
                return NSLocalizedString("provide_jobTitle", comment: "")
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
        
        let backAction = input.backTrigger.do(onNext: { [unowned self]() in
            self.navigator.toBack()
        }).mapToVoid()
        
        let loginAction = input.loginTrigger.do(onNext: { [unowned self]() in
            self.navigator.toLogin()
        }).mapToVoid()
        
        let tasSegue = input.TASSegueTrigger.do(onNext: { [unowned self]() in
            self.navigator.toTAS()
        }).mapToVoid()
        
        let fetching = activityIndicator.asDriver()
        let errors = errorTracker.asDriver()
        return Output(registerAction: register, loginAction: loginAction, workPermitAction: workPermit, TASAction: tas, TASSegueAction: tasSegue, canRegister: canRegister, nameError: nameCorrect, jobError: jobCorrect, emailError: emailCorrect, passwordError: passCorrect,backAction: backAction, error: errors, isFetching: fetching)
    }
    
}

extension RegisterViewModel {
    struct Input {
        let registerTrigger: Driver<Void>
        let loginTrigger: Driver<Void>
        let workPermitTrigger: Driver<Void>
        let TASTrigger: Driver<Void>
        let TASSegueTrigger: Driver<Void>
        let name: Driver<String>
        let job: Driver<String>
        let email: Driver<String>
        let password: Driver<String>
        let backTrigger: Driver<Void>
    }
    
    struct Output {
        let registerAction: Driver<Void>
        let loginAction: Driver<Void>
        let workPermitAction: Driver<Bool>
        let TASAction: Driver<Bool>
        let TASSegueAction: Driver<Void>
        let canRegister: Driver<Bool>
        let nameError: Driver<String>
        let jobError: Driver<String>
        let emailError: Driver<String>
        let passwordError: Driver<[[String: String]]>
        let backAction: Driver<Void>
        let error: Driver<Error>
        let isFetching: Driver<Bool>
        
    }
    
}
