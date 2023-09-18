//
//  HomeNavigator.swift
//  MondayJobs
//
//  Created by Ashkan Ghaderi on 11/12/20.
//  Copyright © 2020 Elinium. All rights reserved.
//

import Foundation
import Domain
import NetworkPlatform
import UIKit

class HomeNavigator {
    
    private let navigationController: UINavigationController
    private let services: Domain.UseCaseProvider
    
    init(services: Domain.UseCaseProvider, navigationController: UINavigationController) {
        self.services = services
        self.navigationController = navigationController
    }
    
    func setup() {
        let homeVC = HomeViewController(nibName: "HomeViewController", bundle: nil)
        homeVC.viewModel = HomeViewModel(navigator: self, useCase: services.makeHomeUseCase())
        navigationController.pushViewController(homeVC, animated: true)
    }
    
    func toCompanyPage(id: String){
        CompanyNavigator(services: services, navigationController: navigationController).setup(id: id)
    }
    
    func toWatchList(){
        WatchNavigator(services: services, navigationController: navigationController).setup()
    }
    
    
    func toErrorPage(error: Error) {
        
    }
    
    func toProfile() {
        ProfileNavigator(services: services, navigationController: navigationController).setup()
    }
    
    
}
