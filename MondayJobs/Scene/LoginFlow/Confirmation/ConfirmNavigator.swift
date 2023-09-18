//
//  ConfirmNavigator.swift
//  MondayJobs
//
//  Created by Ashkan Ghaderi on 2/16/21.
//  Copyright © 2021 Elinium. All rights reserved.
//

import Foundation
import Domain
import NetworkPlatform
import UIKit

class ConfirmNavigator {
    
    private let navigationController: UINavigationController
    private let services: Domain.UseCaseProvider
    
    init(services: Domain.UseCaseProvider, navigationController: UINavigationController) {
        self.services = services
        self.navigationController = navigationController
    }
    
    func setup() {
        let comVC = ConfirmViewController(nibName: "ConfirmViewController", bundle: nil)
        comVC.viewModel = ConfirmViewModel(navigator: self, useCase: services.makeAuthenticationUseCase())
        navigationController.pushViewController(comVC, animated: true)
    }
    
    
    func toErrorPage(error: Error) {
        
    }
    
    func toHome(){
        HomeNavigator(services: services, navigationController: navigationController).setup()
    }
    
    
}
