//
//  AuthorizationService.swift
//  NetworkPlatform
//
//  Created by Ashkan Ghaderi on 8/8/20.
//  Copyright © 2020 Elinium. All rights reserved.
//

import Foundation
import RxSwift
import Domain


public final class AuthorizationService{
    
    private let network: Network
    
    init(network: Network) {
        self.network = network
    }
    
    public func login(_ Parameters: LoginModel.Request) -> Observable<LoginModel.Response>{
        
        let url = ServiceRouter.AuthServiceRoute(.login).url
       
        return network.postItem(url: url, param: Parameters.toJSON())
        
    }
    
    public func register(_ Parameters:AttendeeRegisterModel.Request) -> Observable<AttendeeRegisterModel.Response>{
        
        let url = ServiceRouter.AuthServiceRoute(.register).url


        return network.postItem(url: url, param: Parameters.toJSON())
    }
    
    public func requestReset(_ Parameters:RequestResetModel.Request) -> Observable<RequestResetModel.Response>{
        
        let url = ServiceRouter.AuthServiceRoute(.requestreset).url
        
        return network.postItem(url: url, param: Parameters.toJSON())
    }
    
    public func resetPassword(_ Parameters:ResetPasswordModel.Request) -> Observable<ResetPasswordModel.Response>{
        
        let url = ServiceRouter.AuthServiceRoute(.resetpass).url
        
        return network.postItem(url: url, param: Parameters.toJSON())
    }
    
    public func activateUser(code : String) -> Observable<ActivateUserModel.Response>{
        let url = ServiceRouter.AuthServiceRoute(.register).url
        let query = "code=\(code)"
        return network.getItem(url,itemId: query)
    }
    
    public func activateOAuth(_ Parameters:ActivateUserModel.Request,code : String) -> Observable<ActivateUserModel.Response>{
        let url = ServiceRouter.AuthServiceRoute(.activate).url + "?code=\(code)"
        
        return network.postItem(url: url, param: Parameters.toJSON())
    }
    
    public func getProfile() -> Observable<ProfileModel.Response>{
        let url = ServiceRouter.AuthServiceRoute(.profile).url
        
        return network.getItem(url)
    }
    
    public func updateProfile(_ Parameters:ProfileModel.Request) -> Observable<ProfileModel.Response>{
        let url = ServiceRouter.AuthServiceRoute(.profile).url
        
        return network.postItem(url: url, param: Parameters.toJSON())
    }
    
    public func uploadResume(resume: Data) -> Observable<ProfileModel.Response> {
        let url = ServiceRouter.AuthServiceRoute(.resume).url
        
        return network.uploadFile(file: resume, url: url, param: nil, fileType: .pdf)
    }
    
    public func uploadAvatar(avatar: Data) -> Observable<ProfileModel.Response> {
        let url = ServiceRouter.AuthServiceRoute(.avatar).url
        
        return network.uploadFile(file: avatar, url: url, param: nil, fileType: .jpg)
    }
    
}
