//
//  LoginNavigator.swift
//  MondayJobs
//
//  Created by Ashkan Ghaderi on 10/31/20.
//  Copyright © 2020 Elinium. All rights reserved.
//

import Foundation
import Domain
import NetworkPlatform
import UIKit

class LoginNavigator {
    
    private let navigationController: UINavigationController
    private let services: Domain.UseCaseProvider
    
    init(services: Domain.UseCaseProvider, navigationController: UINavigationController) {
        self.services = services
        self.navigationController = navigationController
    }
    
    func setup() {
        let LoginVC = LoginViewController(nibName: "LoginViewController", bundle: nil)
        LoginVC.viewModel = LoginViewModel(navigator: self, useCase: services.makeAuthenticationUseCase())
        navigationController.pushViewController(LoginVC, animated: true)
    }
    
    func toHome(){
        
        HomeNavigator(services: services, navigationController: navigationController).setup()
    }
    
    func toErrorPage(error: Error) {
        
    }
    
    func toResetPassword(email : String) {
        ResetPasswordNavigator(services: services, navigationController: navigationController, email: email ).setup()
    }
    
    func Back() {
        LandingNavigator(services: services, navigationController: navigationController).setup()
    }
}
