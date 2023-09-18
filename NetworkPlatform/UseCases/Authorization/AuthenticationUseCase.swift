//
//  SetPhoneUseCase.swift
//  NetworkPlatform
//
//  Created by Ashkan Ghaderi on 8/8/20.
//  Copyright © 2020 Elinium. All rights reserved.
//

import Domain
import RxSwift

public final class AuthenticationUseCase: Domain.AuthenticationUseCase {
    
    
    
    @LazyInjected private var service: AuthorizationService
    
    public func login(request: LoginModel.Request) -> Observable<LoginModel.Response> {
        return service.login(request)
    }
    
    public func RegisterUser(request: AttendeeRegisterModel.Request) -> Observable<AttendeeRegisterModel.Response> {
        return service.register(request)
    }
    
    public func requestReset(request: RequestResetModel.Request) -> Observable<RequestResetModel.Response> {
        return service.requestReset(request)
    }
    
    public func resetPassword(request: ResetPasswordModel.Request) -> Observable<ResetPasswordModel.Response> {
        return service.resetPassword(request)
    }
    
    public func activeteUser(code: String) -> Observable<ActivateUserModel.Response> {
        return service.activateUser(code: code)
    }
    
    public func activeteOAuth(request: ActivateUserModel.Request,code: String) -> Observable<ActivateUserModel.Response> {
        return service.activateOAuth(request, code: code)
    }
    
    public func getProfile() -> Observable<ProfileModel.Response> {
        return service.getProfile()
    }
    
    public func updateProfile(request: ProfileModel.Request) -> Observable<ProfileModel.Response> {
        return service.updateProfile(request)
    }
    
    public func uploadResume(resume: Data) -> Observable<ProfileModel.Response> {
        return service.uploadResume(resume: resume)
    }
    
    public func uploadAvatar(avatar: Data) -> Observable<ProfileModel.Response> {
        return service.uploadAvatar(avatar: avatar)
    }
    
    public func isUserActive() -> Observable<Bool> {
        return Observable.just(true)
    }
    
    public init(){}
   
    
}
