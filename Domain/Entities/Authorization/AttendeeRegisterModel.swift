//
//  ActivationModel.swift
//  Domain
//
//  Created by Ashkan Ghaderi on 8/8/20.
//  Copyright © 2020 Elinium. All rights reserved.
//

import Foundation

public extension AttendeeRegisterModel.Request {
    func toJSON() -> [String: Any] {
        var result: [String:Any] = [:]
        if let name = self.name {
            result["name"] = name
        }
        if let email = self.email {
            result["email"] = email
        }
        if let avatarUrl = self.avatar_url {
            result["avatar_url"] = avatarUrl
        }
        if let password = self.password {
            result["password"] = password
        }
        if let jobTitle = self.job_title {
            result["job_title"] = jobTitle
        }
        if let token = self.token {
            result["token"] = token
        }
        if let provider = self.provider {
            result["provider"] = provider
        }
        if let hasWorkPermit = self.has_work_permit {
            result["has_work_permit"] = hasWorkPermit
        }
        if let tosAccepted = self.tos_accepted {
            result["tos_accepted"] = tosAccepted
        }
        return result

    }
}

public enum AttendeeRegisterModel: InteractiveModelType {
    
    public class Request: Codable {
  
       var name: String?
       var email: String?
       var avatar_url: String?
       var password: String?
       var job_title: String?
       var token: String?
       var provider: String?
       var has_work_permit: Bool?
       var tos_accepted: Bool?
        
        public init(name: String,email: String, password: String, job: String, hasWorkPermit: Bool, tos: Bool) {
            self.name = name
            self.email = email
            self.password = password
            self.job_title = job
            self.has_work_permit = hasWorkPermit
            self.tos_accepted = tos
        }
        
        public init(name: String,email: String
            , token: String, avatar_url: String,provider: String) {
            self.name = name
            self.email = email
            self.token = token
            self.avatar_url = avatar_url
            self.provider = provider
        }
        
        public init(token: String,provider: String) {
            self.token = token
            self.provider = provider
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


