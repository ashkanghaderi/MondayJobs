//
//  ProfileNavigator.swift
//  MondayJobs
//
//  Created by Ashkan Ghaderi on 1/13/21.
//  Copyright © 2021 Elinium. All rights reserved.
//

import Foundation
import Domain
import NetworkPlatform
import UIKit

class ProfileNavigator {
    
    private let navigationController: UINavigationController
    private let services: Domain.UseCaseProvider
    
    init(services: Domain.UseCaseProvider, navigationController: UINavigationController) {
        self.services = services
        self.navigationController = navigationController
    }
    
    func setup() {
        let proVC = ProfileViewController(nibName: "ProfileViewController", bundle: nil)
        proVC.viewModel = ProfileViewModel(navigator: self, useCase: services.makeAuthenticationUseCase())
        navigationController.pushViewController(proVC, animated: true)
    }
    
    
    func toErrorPage(error: Error) {
        
    }
    
    func goBack(){
        navigationController.popViewController(animated: true)
    }
    
    func goLogin(){
        LoginNavigator(services: services, navigationController: navigationController).setup()
    }
    
    
}
