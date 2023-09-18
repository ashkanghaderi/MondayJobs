//
//  ResponseResult.swift
//  Domain
//
//  Created by Ashkan Ghaderi on 8/8/20.
//  Copyright © 2020 Elinium. All rights reserved.
//

import Foundation

public struct ResponseResult: Codable {
    var title: String?
    var status: Int?
    var message: String?
    var level: String?
    
}
