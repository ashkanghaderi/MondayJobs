//
//  UseCaseProvider.swift
//  NetworkPlatform
//
//  Created by Ashkan Ghaderi on 8/8/20.
//  Copyright © 2020 Elinium. All rights reserved.
//

import Foundation
import Domain
import Resolver

public final class UseCaseProvider: Domain.UseCaseProvider
{
    public func makeVideoUseCase() -> Domain.VideoUseCase {
        return VideoUseCase()
    }
    
    public func makeCompanyUseCase() -> Domain.CompanyUseCase {
        return CompanyUseCase()
    }
    
    public func makeHomeUseCase() -> Domain.HomeUseCase {
        return HomeUseCase()
    }
    
    public func makeOnBoardingUseCase() -> Domain.OnBoardingUseCase {
        return OnBoardingUseCase()
    }
    
    public func makeAuthenticationUseCase() -> Domain.AuthenticationUseCase {
        return AuthenticationUseCase()
    }
    
    
    public init() {}
    
}

