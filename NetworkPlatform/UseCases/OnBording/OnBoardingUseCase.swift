//
//  CommonInfoUseCase.swift
//  NetworkPlatform
//
//  Created by Ashkan Ghaderi on 7/18/20.
//  Copyright © 2020 myDigiPay. All rights reserved.
//

import Foundation
import Domain
import RxSwift
public final class OnBoardingUseCase: Domain.OnBoardingUseCase {
   
   @LazyInjected private var service: OnBoardingService

    public func fetchOnBoarding() -> Observable<OnBoardingModel> {
        return service.fetchOnBoarding()
    }
    
    public init(){}
}
