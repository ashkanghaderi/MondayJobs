

import Foundation
import Domain
import UIKit

class SplashNavigator {
    
    private let navigationController: UINavigationController
    private let services: UseCaseProvider
    
    init(navigationController: UINavigationController, services: UseCaseProvider) {
        self.navigationController = navigationController
        self.services = services
    }
    
    func setup() {
        let splashVC = SplashViewController(nibName: "SplashViewController", bundle: nil)
        splashVC.viewModel = SplashViewModel(navigator: self, useCase: services.makeAuthenticationUseCase())
        navigationController.viewControllers = [splashVC]
    }
    
    func toHome() {
        
        HomeNavigator(services: services, navigationController: navigationController).setup()
    }
    
    func toLanding() {
        
        LandingNavigator(services: services, navigationController: navigationController).setup()
    }
    
    func toOnboarding() {
        
       OnBoardingNavigator(navigationController: navigationController, services: services).setup()
    }
    
}
