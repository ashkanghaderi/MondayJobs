//
//  CompanyMenuNavigator.swift
//  MondayJobs
//
//  Created by Ashkan Ghaderi on 1/19/21.
//  Copyright © 2021 Elinium. All rights reserved.
//

import Foundation
import UIKit
import Domain
import NetworkPlatform

class CompanyMenuNavigator {
    
    private let navigationController: UINavigationController
    private let services: Domain.UseCaseProvider
    
    init(services: Domain.UseCaseProvider, navigationController: UINavigationController) {
        self.services = services
        self.navigationController = navigationController
    }
    
    func setup(companyId: String) {
        let menuVC = CompanyMenuViewController(nibName: "CompanyMenuViewController", bundle: nil)
        menuVC.viewModel = CompanyMenuViewModel(navigator: self, useCase: services.makeHomeUseCase(),companyId: companyId)
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
