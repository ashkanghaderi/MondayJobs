//
//  CompanyService.swift
//  NetworkPlatform
//
//  Created by Ashkan Ghaderi on 1/2/21.
//  Copyright © 2021 Elinium. All rights reserved.
//

import Foundation
import RxSwift
import Domain

public final class CompanyService{
    
    private let network: Network
    
    init(network: Network) {
        self.network = network
    }
    
    public func fetchCompany(id : String) -> Observable<CompanyModel.Response>{
        let url = ServiceRouter.CompanyServiceRoute(.company).url
        let query = "id=\(id)"
        return network.getItem(url,itemId: query)
    }
   
}
