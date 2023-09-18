//
//  ExtraInfoNavigator.swift
//  MondayJobs
//
//  Created by Ashkan Ghaderi on 11/2/20.
//  Copyright © 2020 Elinium. All rights reserved.
//

import Foundation
import Domain
import NetworkPlatform
import UIKit

class ExtraInfoNavigator {
    
    private let navigationController: UINavigationController
    private let services: Domain.UseCaseProvider
    private let personAvatar: String
    private let personName: String
    private let code: String
    
    init(services: Domain.UseCaseProvider, navigationController: UINavigationController,personAvatar: String,personName: String,code: String) {
        self.services = services
        self.navigationController = navigationController
        self.personAvatar = personAvatar
        self.personName = personName
        self.code = code
    }
    
    func setup() {
        let extraVC = ExtraInfoViewController(nibName: "ExtraInfoViewController", bundle: nil)
        extraVC.viewModel = ExtraInfoViewModel(navigator: self, useCase: services.makeAuthenticationUseCase(),personAvatar: self.personAvatar,personName: self.personName,code: self.code)
        navigationController.pushViewController(extraVC, animated: true)
    }
    
    func toTAS(){
        
    }
    
    func toHome(){
        let tabbar = UITabBarController()
        MainTabbarNavigator(services: services, navigationController: navigationController, tabbar: tabbar).setup()
    }
    
  func toErrorPage(error: Error) {
        
    }
}
