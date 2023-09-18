
import Foundation
import Domain
import UIKit

class OnBoardingNavigator {
    
    private let navigationController: UINavigationController
    private let services: UseCaseProvider
    
    init(navigationController: UINavigationController, services: UseCaseProvider) {
        self.navigationController = navigationController
        self.services = services
    }
    
    func setup() {
        let onboardingVC = OnBoardingViewController(nibName: "OnBoardingViewController", bundle: nil)
        onboardingVC.viewModel = OnBoardingViewModel(navigator: self, useCase: services.makeOnBoardingUseCase())
        navigationController.viewControllers = [onboardingVC]
    }
    
    func toRegister() {

        LandingNavigator(services: services, navigationController: navigationController).setup()
    }
    
    func toLanding() {

        LandingNavigator(services: services, navigationController: navigationController).setup()
    }
    
    func toLogin() {
        LoginNavigator(services: services, navigationController: navigationController).setup()
    }
}


