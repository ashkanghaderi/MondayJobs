//
//  VideoChatViewModel.swift
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

final class VideoViewModel: ViewModelType {
    
    public let navigator: VideoNavigator
    private let useCase: Domain.VideoUseCase
    public var roomModel: VideoRoomModel
    init( navigator: VideoNavigator, useCase: Domain.VideoUseCase,roomModel: VideoRoomModel) {
        self.useCase = useCase
        self.navigator = navigator
        self.roomModel = roomModel
    }
    
    func transform(input: Input) -> Output {
        let activityIndicator = ActivityIndicator()
        let errorTracker = ErrorTracker()
        

        let agentName = Driver.just(roomModel.agentName ?? "")
        let agentPosition = Driver.just(roomModel.agentPosition ?? "")
        
//        let load = input.loadTrigger.flatMapLatest{ [unowned self]  in
//            return self.useCase.roomInit().trackActivity(activityIndicator).trackError(errorTracker)
//                .asDriverOnErrorJustComplete()
//                .map{ result -> VideoModel in
//                    return VideoModel(result)
//                }
//
//        }

        let disconnectAction = input.disconnectTrigger.flatMapLatest{ [unowned self]  in
            return self.useCase.roomLeft().trackActivity(activityIndicator).trackError(errorTracker)
                .asDriverOnErrorJustComplete()
            
        }
        
        let agentId = Driver.of(roomModel.agentId)
        
        let joinAction = input.joinTrigger.withLatestFrom(agentId).flatMapLatest{[unowned self] id in
            return self.useCase.roomJoin(agentId: id!).trackActivity(activityIndicator).trackError(errorTracker)
                .asDriverOnErrorJustComplete()
                .map{ result -> VideoModel in
                    return VideoModel(result)
                }
        }
        
//        let backAction = input.backTrigger.flatMapLatest{ [unowned self]  in
//            return self.useCase.roomClose().trackActivity(activityIndicator).trackError(errorTracker)
//                .asDriverOnErrorJustComplete()
//            
//        }.do(onNext: self.navigator.goBack)
        
        let backAction = input.backTrigger.do(onNext: { [unowned self]() in
            self.navigator.goBack("")
        }).mapToVoid()
        
        
        let fetching = activityIndicator.asDriver()
        let errors = errorTracker.asDriver()
        
        return Output(agentName: agentName, agentPosition: agentPosition,joinAction: joinAction, backAction: backAction, disconnectAction: disconnectAction, error: errors, isFetching: fetching)
    }
    
}

extension VideoViewModel {
    struct Input {
        
        let disconnectTrigger: Driver<Void>
        let backTrigger: Driver<Void>
        let joinTrigger: Driver<Void>

    }
    
    struct Output {
        let agentName: Driver<String>
        let agentPosition: Driver<String>
        let joinAction: Driver<VideoModel>
        let backAction: Driver<Void>
        let disconnectAction: Driver<Bool>
        let error: Driver<Error>
        let isFetching: Driver<Bool>
        
    }
    
}

