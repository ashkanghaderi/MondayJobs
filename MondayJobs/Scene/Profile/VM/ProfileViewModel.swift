//
//  ProfileViewModel.swift
//  MondayJobs
//
//  Created by Ashkan Ghaderi on 1/13/21.
//  Copyright © 2021 Elinium. All rights reserved.
//

import Foundation
import Foundation
import Domain
import NetworkPlatform
import RxCocoa
import RxSwift

final class ProfileViewModel: ViewModelType {
    
    private let navigator: ProfileNavigator
    private let useCase: Domain.AuthenticationUseCase
    init( navigator: ProfileNavigator, useCase: Domain.AuthenticationUseCase) {
        self.useCase = useCase
        self.navigator = navigator
    }
    
    func transform(input: Input) -> Output {
        
        let activityIndicator = ActivityIndicator()
        let errorTracker = ErrorTracker()
        
        let automaticResumeSharing = input.resumeSharing.scan(false) { sharing, _ in
            return !sharing
        }.startWith(false)
        
        let automaticLinkedinSharing = input.linkedinSharing.scan(false) { sharing, _ in
            return !sharing
        }.startWith(false)
        
        let avatar = input.uploadImageTrigger.flatMapLatest{ [unowned self] model in
            return self.useCase.uploadAvatar(avatar: model.data!).trackActivity(activityIndicator).trackError(errorTracker)
                .asDriverOnErrorJustComplete()
                .map{ result -> ProfileModel in
                    return ProfileModel(result)
                }
            
        }
        
        let resume = input.uploadResumeTrigger.flatMapLatest{ [unowned self] data in
            return self.useCase.uploadResume(resume: data).trackActivity(activityIndicator).trackError(errorTracker)
                .asDriverOnErrorJustComplete()
                .map{ result -> ProfileModel in
                    return ProfileModel(result)
                }
            
        }
        
        let profileStaff = Driver.combineLatest(automaticResumeSharing,automaticLinkedinSharing,input.linkedin,input.jobTitle,input.pitchText)
        
       

        let load = input.loadTrigger.flatMapLatest{ [unowned self]  in
            return self.useCase.getProfile().trackActivity(activityIndicator).trackError(errorTracker)
                .asDriverOnErrorJustComplete()
                .map{ result -> ProfileModel in
                    return ProfileModel(result)
                }
            
        }
        
        let saveAction = input.doneTrigger.withLatestFrom(profileStaff).map { (resumeSharing, linkedinSharing, linkedin,jobTitle, pitchText) ->  Domain.ProfileModel.Request in
            return Domain.ProfileModel.Request(about: pitchText,linkedin: linkedin,jobTitle: jobTitle,shareResume: resumeSharing,shareLinkedin: linkedinSharing)
            
        }.flatMapLatest {
            return self.useCase.updateProfile(request: $0).trackActivity(activityIndicator).trackError(errorTracker)
                .asDriverOnErrorJustComplete()
                .map{ result -> ProfileModel in
                    return ProfileModel(result)
                }
        }
        
        let backAction = input.backTrigger.do(onNext: { _ in
            self.navigator.goBack()
        }).mapToVoid()
        
        let logoutAction = input.logoutTrigger.do(onNext: { _ in
            AuthorizationInfo.clearAuth()
            self.navigator.goLogin()
        }).mapToVoid()
        
        
        let fetching = activityIndicator.asDriver()
        let errors = errorTracker.asDriver()
        
        return Output(backAction: backAction, doneAction: saveAction, loadAction: load, uploadResumeAction: resume, uploadImageAction: avatar, logoutAction: logoutAction, error: errors, isFetching: fetching)
    }
    
}

extension ProfileViewModel {
    struct Input {
        let jobTitle: Driver<String>
        let pitchText: Driver<String>
        let linkedin: Driver<String>
        let resumeSharing: Driver<Bool>
        let linkedinSharing: Driver<Bool>
        let uploadResumeTrigger: Driver<Data>
        let uploadImageTrigger: Driver<UploadFileModel>
        let logoutTrigger: Driver<Void>
        let doneTrigger: Driver<Void>
        let loadTrigger: Driver<Void>
        let backTrigger: Driver<Void>

    }
    
    struct Output {
        
        let backAction: Driver<Void>
        let doneAction: Driver<ProfileModel>
        let loadAction: Driver<ProfileModel>
        let uploadResumeAction: Driver<ProfileModel>
        let uploadImageAction: Driver<ProfileModel>
        let logoutAction: Driver<Void>
        let error: Driver<Error>
        let isFetching: Driver<Bool>
        
    }
    
}

