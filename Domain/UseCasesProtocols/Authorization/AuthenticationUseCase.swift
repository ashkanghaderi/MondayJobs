//
//  AuthenticationUseCase.swift
//  Domain
//
//  Created by Ashkan Ghaderi on 10/17/20.
//  Copyright © 2020 Elinium. All rights reserved.
//

import Foundation
import RxSwift

public protocol AuthenticationUseCase {
    func RegisterUser(request: AttendeeRegisterModel.Request) -> Observable<AttendeeRegisterModel.Response>
    
    func login(request: LoginModel.Request) -> Observable<LoginModel.Response>
    
    func requestReset(request: RequestResetModel.Request) -> Observable<RequestResetModel.Response>
    
    func resetPassword(request: ResetPasswordModel.Request) -> Observable<ResetPasswordModel.Response>
    
    func activeteUser(code: String) -> Observable<ActivateUserModel.Response>
    
    func activeteOAuth(request: ActivateUserModel.Request,code: String) -> Observable<ActivateUserModel.Response>
    
    func getProfile() -> Observable<ProfileModel.Response>
    
    func updateProfile(request: ProfileModel.Request) -> Observable<ProfileModel.Response>
    
    func uploadResume(resume: Data) -> Observable<ProfileModel.Response>
    
    func uploadAvatar(avatar: Data) -> Observable<ProfileModel.Response>
    
    func isUserActive() -> Observable<Bool>
    
}
