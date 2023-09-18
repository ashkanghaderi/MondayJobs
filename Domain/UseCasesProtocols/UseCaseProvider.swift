//
//  UseCaseProvider.swift
//  Domain
//
//  Created by Ashkan Ghaderi on 8/8/20.
//  Copyright © 2020 Elinium. All rights reserved.
//

import Foundation

public protocol UseCaseProvider {
    
    func makeHomeUseCase() -> HomeUseCase
    
    func makeOnBoardingUseCase() -> OnBoardingUseCase
    
    func makeAuthenticationUseCase() -> AuthenticationUseCase
    
    func makeCompanyUseCase() -> CompanyUseCase
    
    func makeVideoUseCase() -> VideoUseCase
    
}
