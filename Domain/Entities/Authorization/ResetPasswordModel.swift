//
//  ResetPasswordModel.swift
//  Domain
//
//  Created by Ashkan Ghaderi on 10/17/20.
//  Copyright © 2020 Elinium. All rights reserved.
//

import Foundation

public extension ResetPasswordModel.Request {
    func toJSON() -> [String: Any] {
        var result: [String:Any] = [:]
        
        if let email = self.email {
            result["email"] = email
        }
        
        if let password = self.password {
            result["password"] = password
        }
        
        return result
        
    }
}

public enum ResetPasswordModel: InteractiveModelType {
    
    public struct Request: Codable {
        
        public var email: String?
        public var password: String?
        
        public init(email: String, password: String){
            self.email = email
            self.password = password
        }
        
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
