//
//  DeviceModel.swift
//  Domain
//
//  Created by Ashkan Ghaderi on 8/8/20.
//  Copyright © 2020 Elinium. All rights reserved.
//

import Foundation

public struct DeviceModel: Codable {
    
    let imei: String?
    let deviceId: String?
    let deviceModel: String?
    let deviceAPI: String?
    let osVersion: String?
    let osName: String?
    let appVersion: String?
    let displaySize: String?
    let manufacure: String?
    let brand: String?
    let fireBaseToken: String?

    
}
