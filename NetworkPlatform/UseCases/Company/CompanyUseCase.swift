//
//  CompanyUseCase.swift
//  NetworkPlatform
//
//  Created by Ashkan Ghaderi on 1/2/21.
//  Copyright © 2021 Elinium. All rights reserved.
//

import Foundation
import Domain
import RxSwift
public final class CompanyUseCase: Domain.CompanyUseCase {

    @LazyInjected private var service: CompanyService
    
    public init(){}
    
    public func fetchCompany(id: String) -> Observable<CompanyModel.Response> {
        return service.fetchCompany(id: id)
    }
    
}
