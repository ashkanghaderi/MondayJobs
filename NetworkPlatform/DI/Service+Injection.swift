
import Foundation
import Resolver
import Domain

extension Resolver{
    
    public static func  ServiceInjection(){
        register(AuthorizationService.self)          {AuthorizationService(network: Network(BaseURL.dev.rawValue))}
        register(OnBoardingService.self)             {OnBoardingService(network: Network(BaseURL.dev.rawValue))}
        register(HomeService.self)                   {HomeService(network: Network(BaseURL.dev.rawValue))}
        register(CompanyService.self)                   {CompanyService(network: Network(BaseURL.dev.rawValue))}
        register(VideoService.self)                   {VideoService(network: Network(BaseURL.dev.rawValue))}
    }
    
}

