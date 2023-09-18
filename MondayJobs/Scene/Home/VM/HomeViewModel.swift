//
//  HomeViewModel.swift
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

final class HomeViewModel: ViewModelType {
    
    public let navigator: HomeNavigator
    private let useCase: Domain.HomeUseCase
    
    init( navigator: HomeNavigator, useCase: Domain.HomeUseCase) {
        self.useCase = useCase
        self.navigator = navigator
    }
    
    func transform(input: Input) -> Output {
        let activityIndicator = ActivityIndicator()
        let errorTracker = ErrorTracker()
        
        let userName = Driver.just(AuthorizationInfo.get(by: "name") ?? "")
        let jobTitle = Driver.just(AuthorizationInfo.get(by: "jobTitle") ?? "")
        let imageUrl = Driver.just(AuthorizationInfo.get(by: "avatarUrl") ?? "")
        
        let exhibition = input.viewWillAppearTrigger.flatMapLatest {
            return self.useCase.fetchExhibition()
                .trackActivity(activityIndicator)
                .trackError(errorTracker)
                .asDriverOnErrorJustComplete()
                .map {  ExhibitionModel($0) }
        }
        
        let sugesstions = Driver.just([SuggesstionModel(icon: "https://www.logaster.com/blog/wp-content/uploads/2018/04/Warner-Brosers-logo-history.png", companyName: "Warnner brothers", companyDesc: "Film Company", salary: "£ 180k - £ 240k", jobTitle: "Product Designer"),SuggesstionModel(icon: "https://www.logaster.com/blog/wp-content/uploads/2018/04/NASA-logo-history.png", companyName: "NASA", companyDesc: "Space Company", salary: "£ 220k - £ 310k", jobTitle: "Product Designer"),SuggesstionModel(icon: "https://www.logaster.com/blog/wp-content/uploads/2018/04/LEGO-logo-history.png", companyName: "LEGO", companyDesc: "Toy Company", salary: "£ 1M - £ 4M", jobTitle: "iOS Developer")])
        
        let notificationAction = input.NotificationTrigger.do(onNext: { _ in
            self.navigator.toWatchList()
        }).mapToVoid()
        
        let profileAction = input.profileTrigger.do(onNext: { _ in 
            self.navigator.toProfile()
        }).mapToVoid()
        
        
        let fetching = activityIndicator.asDriver()
        let errors = errorTracker.asDriver()
        
        return Output(NotificationAction: notificationAction, profileAction: profileAction, exhibition: exhibition, suggesstions: sugesstions, userName: userName, jobTitle: jobTitle, imageUrl: imageUrl, error: errors, isFetching: fetching)
    }
    
    func searchPanels(query: String) -> Observable<[PanelModel]>{
        
        return self.useCase.searchExhibition(query: query).asObservable()
            .map { $0.map {PanelModel($0)} }
    }
    
}

extension HomeViewModel {
    struct Input {
        
        let NotificationTrigger: Driver<Void>
        let viewWillAppearTrigger: Driver<Void>
        let profileTrigger: Driver<Void>
        
    }
    
    struct Output {
        let NotificationAction: Driver<Void>
        let profileAction: Driver<Void>
        let exhibition: Driver<ExhibitionModel>
        let suggesstions: Driver<[SuggesstionModel]>
        let userName: Driver<String>
        let jobTitle: Driver<String>
        let imageUrl: Driver<String>
        let error: Driver<Error>
        let isFetching: Driver<Bool>
        
    }
    
}

