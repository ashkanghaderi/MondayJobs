//
//  Result.swift
//  Domain
//
//  Created by Ashkan Ghaderi on 10/28/20.
//  Copyright © 2020 Elinium. All rights reserved.
//

import Foundation

public enum Result<T> {
    case success(value: T)
    case failure(error: Error)
}
