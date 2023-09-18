//
//  ConfirmViewModel.swift
//  MondayJobs
//
//  Created by Ashkan Ghaderi on 2/16/21.
//  Copyright © 2021 Elinium. All rights reserved.
//

import Foundation
import Domain
import NetworkPlatform
import RxCocoa
import RxSwift

final class ConfirmViewModel: ViewModelType {
    
    public let navigator: ConfirmNavigator
    private let useCase: Domain.AuthenticationUseCase
    
    init( navigator: ConfirmNavigator, useCase: Domain.AuthenticationUseCase) {
        self.useCase = useCase
        self.navigator = navigator
    }
    
    func transform(input: Input) -> Output {
        let activityIndicator = ActivityIndicator()
        let errorTracker = ErrorTracker()
        
        let isActive = input.confirmTestTrigger.flatMapLatest{ [unowned self] in
            return self.useCase.isUserActive().trackActivity(activityIndicator).trackError(errorTracker)
                .asDriverOnErrorJustComplete()
        }
        
        let fetching = activityIndicator.asDriver()
        let errors = errorTracker.asDriver()
        
        return Output(isActive: isActive,error: errors, isFetching: fetching)
    }
    
}

extension ConfirmViewModel {
    struct Input {
        
        let confirmTestTrigger: Driver<Void>
        
    }
    
    struct Output {
        
        let isActive: Driver<Bool>
        let error: Driver<Error>
        let isFetching: Driver<Bool>
        
    }
    
}

