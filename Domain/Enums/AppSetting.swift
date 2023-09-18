//
//  AppSetting.swift
//  Domain
//
//  Created by Ashkan Ghaderi on 8/8/20.
//  Copyright © 2020 Elinium. All rights reserved.
//

import Foundation


public struct AppSetting {
    public static let API_VERSION = "1.0"
    static var ServerMode:Bool = false
    
    static var clientVersion = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? ""
    private static let SECERT_ID = "ios-secret-pazz"
    private static let CLIENT_ID = "ios-client-id"
    public static let APP_ID = "i_1KSuS2#m3AhmauPA"
    
    
    public static let headers : [String:String] =  ["app_id":APP_ID,
                           "Authorization":"Basic \(BASIC_TOKEN_HASH)"]

    public static let BASIC_TOKEN_HASH = {
        return "\(AppSetting.CLIENT_ID):\(AppSetting.SECERT_ID)"
            .data(using: .utf8)?
            .base64EncodedString() ?? ""
    }()
    
}
