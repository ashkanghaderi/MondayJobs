//
//  RefreshTokenModel.swift
//  Domain
//
//  Created by Ashkan Ghaderi on 8/8/20.
//  Copyright © 2020 Elinium. All rights reserved.
//

import Foundation

public enum RefreshTokenModel: InteractiveModelType {
    
    public struct Request: Codable {
       
    }
    
    public struct Response: Codable {
        public var name : String?
        public var email: String?
        public var avatar_url: String?
        public var about: String?
        public var is_new: Bool?
        public var is_active: Bool?
        public var jwt_token: String?
        public var access_token: String?
        public var code: String?
    }
}
