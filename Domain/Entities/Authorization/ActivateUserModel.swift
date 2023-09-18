//
//  ActivateUserModel.swift
//  Domain
//
//  Created by Ashkan Ghaderi on 10/17/20.
//  Copyright © 2020 Elinium. All rights reserved.
//

import Foundation

public extension ActivateUserModel.Request {
    func toJSON() -> [String: Any] {
        var result: [String:Any] = [:]
        if let about = self.about {
            result["about"] = about
        }
       
        if let jobTitle = self.job_title {
            result["job_title"] = jobTitle
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

public enum ActivateUserModel: InteractiveModelType {
    
    public struct Request: Codable {
        public var about : String?
        public var job_title : String?
        public var has_work_permit : Bool?
        public var tos_accepted : Bool?
        
        public init(job_title: String, has_work_permit: Bool,tos_accepted: Bool){
            self.job_title = job_title
            self.has_work_permit = has_work_permit
            self.tos_accepted = tos_accepted
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
