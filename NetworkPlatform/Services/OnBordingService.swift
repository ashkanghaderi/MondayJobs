//
//  OnBordingService.swift
//  NetworkPlatform
//
//  Created by Ashkan Ghaderi on 8/8/20.
//  Copyright © 2020 Elinium. All rights reserved.
//

import Foundation
import RxSwift

import Domain


public final class OnBoardingService{
    
   private let network: Network
    
    init(network: Network) {
        self.network = network
    }
    
    
    public func fetchOnBoarding() -> Observable<OnBoardingModel>{
        let url = ServiceRouter.AuthServiceRoute(.activate).url
              
               return network.getItem(url)
        
        
    }
    
}


