//
//  LandingViewModel.swift
//  MondayJobs
//
//  Created by Ashkan Ghaderi on 10/21/20.
//  Copyright © 2020 Elinium. All rights reserved.
//

import Foundation
import Domain
import RxCocoa
import RxSwift

final class LandingViewModel: ViewModelType {
    
    public let navigator: LandingNavigator
    public let useCase: Domain.AuthenticationUseCase
    
    init( navigator: LandingNavigator, useCase: Domain.AuthenticationUseCase) {
        self.useCase = useCase
        self.navigator = navigator
    }
    
    func transform(input: Input) -> Output {
        let activityIndicator = ActivityIndicator()
        let errorTracker = ErrorTracker()
        
        let registerAction = input.registerTrigger.do(onNext: { [unowned self]() in
            self.navigator.toRegister()
        }).mapToVoid()
        
        let loginAction = input.loginTrigger.do(onNext: { [unowned self]() in
            self.navigator.toLogin()
        }).mapToVoid()
        
        let googleAction = input.googleTrigger.do(onNext: { [unowned self]() in
            
        }).mapToVoid()
        
        let linkdinAction = input.linkdinTrigger.do(onNext: { [unowned self]() in
            
        }).mapToVoid()
        
        
        
        
        let fetching = activityIndicator.asDriver()
        let errors = errorTracker.asDriver()
        return Output(registerAction: registerAction, loginAction: loginAction, googleAction: googleAction, linkdinAction: linkdinAction, error: errors, isFetching: fetching)
    }
    
}

extension LandingViewModel {
    struct Input {
        let registerTrigger: Driver<Void>
        let loginTrigger: Driver<Void>
        let googleTrigger: Driver<Void>
        let linkdinTrigger: Driver<Void>
    }
    
    struct Output {
        let registerAction: Driver<Void>
        let loginAction: Driver<Void>
        let googleAction: Driver<Void>
        let linkdinAction: Driver<Void>
        let error: Driver<Error>
        let isFetching: Driver<Bool>
        
    }
    
}



