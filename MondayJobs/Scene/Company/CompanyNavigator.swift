//
//  CompanyNavigator.swift
//  MondayJobs
//
//  Created by Ashkan Ghaderi on 11/12/20.
//  Copyright © 2020 Elinium. All rights reserved.
//

import Foundation
import Domain
import NetworkPlatform
import UIKit

class CompanyNavigator {
    
    private let navigationController: UINavigationController
    private let services: Domain.UseCaseProvider
    
    init(services: Domain.UseCaseProvider, navigationController: UINavigationController) {
        self.services = services
        self.navigationController = navigationController
    }
    
    func setup(id: String) {
        let comVC = CompanyViewController(nibName: "CompanyViewController", bundle: nil)
        comVC.viewModel = CompanyViewModel(navigator: self, useCase: services.makeCompanyUseCase(),companyId: id)
        navigationController.pushViewController(comVC, animated: true)
    }
    
    
    func toErrorPage(error: Error) {
        
    }
    
    func toMenu(companyId: String){
        CompanyMenuNavigator(services: services, navigationController: navigationController).setup(companyId: companyId)
    }
    
    func toVideoCall(roomModel: VideoRoomModel) {
        VideoNavigator(services: services, navigationController: navigationController).setup(roomModel: roomModel)
    }
    
    func goBack(){
        navigationController.popViewController(animated: true)
    }
    
    
}
