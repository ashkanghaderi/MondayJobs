//
//  MenuNavigator.swift
//  MondayJobs
//
//  Created by Ashkan Ghaderi on 12/23/20.
//  Copyright © 2020 Elinium. All rights reserved.
//

import Foundation
import Domain
import NetworkPlatform
import UIKit

class WatchNavigator {
    
    private let navigationController: UINavigationController
    private let services: Domain.UseCaseProvider
    
    init(services: Domain.UseCaseProvider, navigationController: UINavigationController) {
        self.services = services
        self.navigationController = navigationController
    }
    
    func setup() {
        let menuVC = WatchViewController(nibName: "WatchViewController", bundle: nil)
        menuVC.viewModel = WatchViewModel(navigator: self, useCase: services.makeHomeUseCase())
        menuVC.modalPresentationStyle = .overCurrentContext
        menuVC.modalTransitionStyle = .crossDissolve
        navigationController.present(menuVC, animated: true)
    }
    
    func toMenuItem(menuItem: WatchModel){
        navigationController.dismiss(animated: true, completion: nil)
        CompanyNavigator(services: services, navigationController: navigationController).setup(id: menuItem.companyId ?? "")
    }
    
    func dismiss(){
        navigationController.dismiss(animated: true, completion: nil)
    }
    func toErrorPage(error: Error) {
        
    }
    
    
}
