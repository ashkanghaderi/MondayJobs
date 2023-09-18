//
//  CompanyUseCase.swift
//  Domain
//
//  Created by Ashkan Ghaderi on 1/2/21.
//  Copyright © 2021 Elinium. All rights reserved.
//

import Foundation
import RxSwift

public protocol CompanyUseCase {
    func fetchCompany(id: String) -> Observable<CompanyModel.Response>
}
