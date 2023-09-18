//
//  RegisterNavigator.swift
//  MondayJobs
//
//  Created by Ashkan Ghaderi on 10/21/20.
//  Copyright © 2020 Elinium. All rights reserved.
//

import Foundation
import Domain
import NetworkPlatform
import UIKit

class RegisterNavigator {
    
    private let navigationController: UINavigationController
    private let services: Domain.UseCaseProvider
    
    init(services: Domain.UseCaseProvider, navigationController: UINavigationController) {
        self.services = services
        self.navigationController = navigationController
    }
    
    func setup() {
        let RegisterVC = RegisterViewController(nibName: "RegisterViewController", bundle: nil)
        RegisterVC.viewModel = RegisterViewModel(navigator: self, useCase: services.makeAuthenticationUseCase())
        navigationController.pushViewController(RegisterVC, animated: true)
    }
    
    func toGetExtraInfo(){
        
    }
    
    func toLogin(){
        LoginNavigator(services: services, navigationController: navigationController).setup()
    }
    
    func toTAS(){
        
    }
    
    func toBack(){
        navigationController.popViewController(animated: true)
    }
    
    func toHome(){
        HomeNavigator(services: services, navigationController: navigationController).setup()
    }
    
    func toConfirm(){
        ConfirmNavigator(services: services, navigationController: navigationController).setup()
    }
    
  func toErrorPage(error: Error) {
        
    }
}
