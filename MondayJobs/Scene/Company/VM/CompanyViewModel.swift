//
//  CompanyViewModel.swift
//  MondayJobs
//
//  Created by Ashkan Ghaderi on 11/12/20.
//  Copyright © 2020 Elinium. All rights reserved.
//

import Foundation
import Domain
import NetworkPlatform
import RxCocoa
import RxSwift

final class CompanyViewModel: ViewModelType {
    
    public let navigator: CompanyNavigator
    private let useCase: Domain.CompanyUseCase
    private var companyId: String
    init( navigator: CompanyNavigator, useCase: Domain.CompanyUseCase,companyId: String) {
        self.useCase = useCase
        self.navigator = navigator
        self.companyId = companyId
    }
    
    func transform(input: Input) -> Output {
        let activityIndicator = ActivityIndicator()
        let errorTracker = ErrorTracker()
        
        let id = Driver.just(self.companyId)
        
        let company = input.loadTrigger.withLatestFrom(id).flatMapLatest{ [unowned self] (id)  in
            return self.useCase.fetchCompany(id: id).trackActivity(activityIndicator).trackError(errorTracker)
                .asDriverOnErrorJustComplete()
                .map{ result -> CompanyModel in
                    return CompanyModel(result)
                }
            
        }

//        let selectedJob = input.selectedJob.withLatestFrom(company){ (index,com) -> JobItemModel in
//            return (com.jobs?[index.item])!
//        }
        
        let menuAction = input.menuTrigger.do(onNext: { _ in
            self.navigator.toMenu(companyId: self.companyId)
        }).mapToVoid()
        
        let optionAction = input.optionTrigger.do(onNext: { _ in
            
        }).mapToVoid()
        
        let backAction = input.backTrigger.do(onNext: { _ in
            self.navigator.goBack()
        }).mapToVoid()
        
        
        
        let fetching = activityIndicator.asDriver()
        let errors = errorTracker.asDriver()
        
        return Output(menuAction: menuAction, backAction: backAction, optionAction: optionAction, companyInfo: company,error: errors, isFetching: fetching)
    }
    
}

extension CompanyViewModel {
    struct Input {
        
        let menuTrigger: Driver<Void>
        let optionTrigger: Driver<Void>
        let loadTrigger: Driver<Void>
        let backTrigger: Driver<Void>
        
    }
    
    struct Output {
        let menuAction: Driver<Void>
        let backAction: Driver<Void>
        let optionAction: Driver<Void>
        let companyInfo: Driver<CompanyModel>
        let error: Driver<Error>
        let isFetching: Driver<Bool>
        
    }
    
}

