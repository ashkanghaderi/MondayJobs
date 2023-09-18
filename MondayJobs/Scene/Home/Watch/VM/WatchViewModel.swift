//
//  MenuViewModel.swift
//  MondayJobs
//
//  Created by Ashkan Ghaderi on 12/23/20.
//  Copyright © 2020 Elinium. All rights reserved.
//

import Foundation
import Domain
import NetworkPlatform
import RxCocoa
import RxSwift

final class WatchViewModel: ViewModelType {
    
    private let navigator: WatchNavigator
    private let useCase: Domain.HomeUseCase
    
    init( navigator: WatchNavigator, useCase: Domain.HomeUseCase) {
        self.useCase = useCase
        self.navigator = navigator
    }
    
    func transform(input: Input) -> Output {
        let activityIndicator = ActivityIndicator()
        let errorTracker = ErrorTracker()
        
        let menuItems = input.viewWillAppearTrigger.flatMapLatest{
            return self.useCase.fetchWatchList()
                .trackActivity(activityIndicator)
                .trackError(errorTracker)
                .asDriverOnErrorJustComplete()
                .map { $0.map { WatchModel($0) } }
        }
        
        let selectedMenu = input.selectMenuItemTrigger
            .withLatestFrom(menuItems) { (indexPath, items) -> WatchModel in
                return items[indexPath.row]
            }.do(onNext: navigator.toMenuItem)
        
        let dismissAction = input.dismissTrigger.do(onNext: { _ in
            self.navigator.dismiss()
        }).mapToVoid()

        
        let fetching = activityIndicator.asDriver()
        let errors = errorTracker.asDriver()
        
        return Output(selectedMenuItem: selectedMenu, menuItems: menuItems, dismissAction: dismissAction, error: errors, isFetching: fetching)
    }
    
}

extension WatchViewModel {
    struct Input {
        
        let selectMenuItemTrigger: Driver<IndexPath>
        let viewWillAppearTrigger: Driver<Void>
        let dismissTrigger: Driver<Void>
        
    }
    
    struct Output {
        
        let selectedMenuItem: Driver<WatchModel>
        let menuItems: Driver<[WatchModel]>
        let dismissAction: Driver<Void>
        let error: Driver<Error>
        let isFetching: Driver<Bool>
        
    }
    
}


