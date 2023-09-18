//
//  CompanyMenuViewModel.swift
//  MondayJobs
//
//  Created by Ashkan Ghaderi on 1/19/21.
//  Copyright © 2021 Elinium. All rights reserved.
//

import Foundation
import Domain
import NetworkPlatform
import RxCocoa
import RxSwift

final class CompanyMenuViewModel: ViewModelType {
    
    private let navigator: CompanyMenuNavigator
    private let useCase: Domain.HomeUseCase
    private var companyId: String
    init( navigator: CompanyMenuNavigator, useCase: Domain.HomeUseCase,companyId: String) {
        self.useCase = useCase
        self.navigator = navigator
        self.companyId = companyId
    }
    
    func transform(input: Input) -> Output {
        let activityIndicator = ActivityIndicator()
        let errorTracker = ErrorTracker()
        
        let addWatch = input.addToWatchTrigger.flatMapLatest{
            return self.useCase.setWatch(companyId: self.companyId)
                .trackActivity(activityIndicator)
                .trackError(errorTracker)
                .asDriverOnErrorJustComplete()
                .map {  WatchModel($0) }
        }
        
        let removeWatch = input.removeFromWatchTrigger.flatMapLatest{
            return self.useCase.deleteWatch(companyId: self.companyId)
                .trackActivity(activityIndicator)
                .trackError(errorTracker)
                .asDriverOnErrorJustComplete()
                .map {  WatchModel($0) }
        }
        
        let reportAction = input.reportTrigger.do(onNext: { _ in
            self.navigator.dismiss()
        }).mapToVoid()
        
        let dismissAction = input.dismissTrigger.do(onNext: { _ in
            self.navigator.dismiss()
        }).mapToVoid()

        
        let fetching = activityIndicator.asDriver()
        let errors = errorTracker.asDriver()
        
        return Output(addToWatchAction: addWatch, removeFromWatchAction: removeWatch, reportAction: reportAction, dismissAction: dismissAction, error: errors, isFetching: fetching)
    }
    
}

extension CompanyMenuViewModel {
    struct Input {

        let addToWatchTrigger: Driver<Void>
        let removeFromWatchTrigger: Driver<Void>
        let reportTrigger: Driver<Void>
        let dismissTrigger: Driver<Void>
        
    }
    
    struct Output {
        
        let addToWatchAction: Driver<WatchModel>
        let removeFromWatchAction: Driver<WatchModel>
        let reportAction: Driver<Void>
        let dismissAction: Driver<Void>
        let error: Driver<Error>
        let isFetching: Driver<Bool>
        
    }
    
}


