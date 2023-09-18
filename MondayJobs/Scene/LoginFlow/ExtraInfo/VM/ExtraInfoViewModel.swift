//
//  ExtraInfoViewModel.swift
//  MondayJobs
//
//  Created by Ashkan Ghaderi on 11/2/20.
//  Copyright © 2020 Elinium. All rights reserved.
//

import Foundation
import Domain
import RxCocoa
import RxSwift

final class ExtraInfoViewModel: ViewModelType {
    
    private let navigator: ExtraInfoNavigator
    private let useCase: Domain.AuthenticationUseCase
    private let personAvatar: String
    private let personName: String
    private let code: String
    
    init( navigator: ExtraInfoNavigator, useCase: Domain.AuthenticationUseCase,personAvatar: String,personName: String,code: String) {
        self.useCase = useCase
        self.navigator = navigator
        self.personAvatar = personAvatar
        self.personName = personName
        self.code = code
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
        
        let personAvatar = Driver.just(self.personAvatar)
        
        let personName = Driver.just(self.personName)
        
        let registerStaff = Driver.combineLatest(input.job, workPermit , tas)
        
        let canRegister = Driver.combineLatest(input.job, workPermit , tas){ ( job, wPermit, tas) in
            return !job.isEmpty && wPermit && tas
        }
        
        let register = input.registerTrigger.withLatestFrom(registerStaff)
            .map { (job, wPermit, tas) -> ActivateUserModel.Request in
                return ActivateUserModel.Request(job_title: job, has_work_permit: wPermit, tos_accepted: tas)
        }
        .flatMapLatest { [unowned self] in
            return self.useCase.activeteOAuth(request: $0, code: self.code)
                .trackActivity(activityIndicator).trackError(errorTracker).do(onNext: { [unowned self](respose) in
                    
                    self.navigator.toHome()
                    })
                .asDriverOnErrorJustComplete().mapToVoid()
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
        
        let tasSegue = input.TASSegueTrigger.do(onNext: { [unowned self]() in
            self.navigator.toTAS()
        }).mapToVoid()
        
        let fetching = activityIndicator.asDriver()
        let errors = errorTracker.asDriver()
        return Output(registerAction: register, workPermitAction: workPermit, TASAction: tas, TASSegueAction: tasSegue, canRegister: canRegister, jobError: jobCorrect,personAvatar: personAvatar,personName: personName, error: errors, isFetching: fetching)
    }
    
}

extension ExtraInfoViewModel {
    struct Input {
        let registerTrigger: Driver<Void>
        let workPermitTrigger: Driver<Void>
        let TASTrigger: Driver<Void>
        let TASSegueTrigger: Driver<Void>
        let job: Driver<String>
    }
    
    struct Output {
        let registerAction: Driver<Void>
        let workPermitAction: Driver<Bool>
        let TASAction: Driver<Bool>
        let TASSegueAction: Driver<Void>
        let canRegister: Driver<Bool>
        let jobError: Driver<String>
        let personAvatar: Driver<String>
        let personName: Driver<String>
        let error: Driver<Error>
        let isFetching: Driver<Bool>
        
    }
    
}
