//
//  CommonInfoUseCase.swift
//  Domain
//
//  Created by Ashkan Ghaderi on 8/8/20.
//  Copyright © 2020 Elinium. All rights reserved.
//

import Foundation
import RxSwift

public protocol OnBoardingUseCase {
  func fetchOnBoarding() -> Observable<OnBoardingModel>
}
