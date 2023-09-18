//
//  ResetPasswordNavigator.swift
//  MondayJobs
//
//  Created by Ashkan Ghaderi on 11/1/20.
//  Copyright © 2020 Elinium. All rights reserved.
//

import Foundation
import Domain
import NetworkPlatform
import UIKit

class ResetPasswordNavigator {
    
    private let navigationController: UINavigationController
    private let services: Domain.UseCaseProvider
    private var email : String
    
    init(services: Domain.UseCaseProvider, navigationController: UINavigationController,email: String) {
        self.services = services
        self.navigationController = navigationController
        self.email = email
    }
    
    func setup() {
        let resetVC = ResetPasswordViewController(nibName: "ResetPasswordViewController", bundle: nil)
        resetVC.viewModel = ResetPasswordViewModel(navigator: self, useCase: services.makeAuthenticationUseCase(),email: self.email)
        navigationController.pushViewController(resetVC, animated: true)
    }
    
    func toErrorPage(error: Error) {
        
    }
    
    func toLogin() {
        LoginNavigator(services: services, navigationController: navigationController).setup()
    }
}
