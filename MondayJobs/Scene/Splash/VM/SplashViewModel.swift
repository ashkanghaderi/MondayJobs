
import Foundation
import RxSwift
import NetworkPlatform
import Domain
import RxSwift
import RxCocoa

final class SplashViewModel : ViewModelType {
    
    private let navigator: SplashNavigator
    private let useCase: Domain.AuthenticationUseCase
    let disposeBag = DisposeBag()
    init( navigator: SplashNavigator, useCase: Domain.AuthenticationUseCase) {
        self.navigator = navigator
        self.useCase = useCase
    }
    
    func transform(input: Input) -> Output {
        let activityIndicator = ActivityIndicator()
        let errorTracker = ErrorTracker()
        let deadlineTime = DispatchTime.now() + .seconds(3)
        let isConnected = Driver.of(AuthorizationInfo.isNetworkAvailable())
        
        let retryAction = input.retryTrigger.do(onNext: { [unowned self]() in
            if AuthorizationInfo.isNetworkAvailable() {
                if AuthorizationInfo.isAuth() {
                    
                    DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
                        self.navigator.toHome()
                    }
                    
                } else {
                    DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
                        if !UserDefaults.standard.bool(forKey:"isOnboardingOpenedBefore"){
                            UserDefaults.standard.set(true, forKey: "isOnboardingOpenedBefore")
                            self.navigator.toOnboarding()
                            
                        } else {
                            self.navigator.toLanding()
                        }
                        
                    }
                    
                }
                
            }
        }).mapToVoid()
        
        let appearAction = input.viewWillAppearTrigger.do(onNext: { [unowned self]() in
            if AuthorizationInfo.isNetworkAvailable() {
                if AuthorizationInfo.isAuth() {
                    
                    DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
                        self.navigator.toHome()
                    }
                    
                } else {
                    DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
                        if !UserDefaults.standard.bool(forKey:"isOnboardingOpenedBefore"){
                            UserDefaults.standard.set(true, forKey: "isOnboardingOpenedBefore")
                            self.navigator.toOnboarding()
                            
                        } else {
                            self.navigator.toLanding()
                            //self.navigator.toHome()
                        }
                        
                    }
                    
                }
                
            }
        }).mapToVoid()
        
        
        let version = Driver.of(UIApplication.appVersion)
        
        
        
        let fetching = activityIndicator.asDriver()
        let errors = errorTracker.asDriver()
        return Output(viewWillAppearAction: appearAction,retryAction: retryAction, version: version, isConnected: isConnected, error: errors, isFetching: fetching)
    }
    
}

extension SplashViewModel {
    struct Input {
        let retryTrigger: Driver<Void>
        let viewWillAppearTrigger: Driver<Void>
    }
    
    struct Output {
        let viewWillAppearAction: Driver<Void>
        let retryAction: Driver<Void>
        let version: Driver<String?>
        let isConnected: Driver<Bool>
        let error: Driver<Error>
        let isFetching: Driver<Bool>
        
    }
    
}

