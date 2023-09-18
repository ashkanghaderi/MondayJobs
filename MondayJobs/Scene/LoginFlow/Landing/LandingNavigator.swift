//
//  LandingNavigator.swift
//  MondayJobs
//
//  Created by Ashkan Ghaderi on 10/21/20.
//  Copyright © 2020 Elinium. All rights reserved.
//

import Foundation
import Domain
import NetworkPlatform
import UIKit

class LandingNavigator {
    
    private let navigationController: UINavigationController
    private let services: Domain.UseCaseProvider
    
    init(services: Domain.UseCaseProvider, navigationController: UINavigationController) {
        self.services = services
        self.navigationController = navigationController
    }
    
    func setup() {
        let landingVC = LandingViewController(nibName: "LandingViewController", bundle: nil)
        landingVC.viewModel = LandingViewModel(navigator: self, useCase: services.makeAuthenticationUseCase())
        navigationController.pushViewController(landingVC, animated: true)
    }
    
    func toGetExtraInfo(personAvatar: String,personName: String,code: String){
        ExtraInfoNavigator(services: self.services, navigationController: self.navigationController, personAvatar: personAvatar, personName: personName, code: code).setup()
    }
    
    func toLogin(){
        LoginNavigator(services: services, navigationController: navigationController).setup()
    }
    
    func toRegister(){
        RegisterNavigator(services: services, navigationController: navigationController).setup()
    }
    
    func toHome(){
        HomeNavigator(services: services, navigationController: navigationController).setup()
    }
    
  func toErrorPage(error: Error) {
        
    }
}
