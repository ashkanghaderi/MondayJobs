//
//  OnboardingModel.swift
//  Domain
//
//  Created by Ashkan Ghaderi on 8/8/20.
//  Copyright © 2020 Elinium. All rights reserved.
//

import Foundation

public struct OnBoardingModel : Codable {
    public let result: ResponseResult?
    public let walkThrough : [WalkThrough]?
}


