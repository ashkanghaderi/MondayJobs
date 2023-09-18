//
//  ProfileModel.swift
//  Domain
//
//  Created by Ashkan Ghaderi on 10/17/20.
//  Copyright © 2020 Elinium. All rights reserved.
//

import Foundation

public extension ProfileModel.Request {
    func toJSON() -> [String: Any] {
        var result: [String:Any] = [:]
        if let about = self.about {
            result["about"] = about
        }
        if let phone = self.phone {
            result["phone"] = phone
        }
        if let resumeUrl = self.resume_url {
            result["resume_url"] = resumeUrl
        }
        if let linkedInUrl = self.linkedIn_url {
            result["linkedIn_url"] = linkedInUrl
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
        if let resumeFileName = self.resume_file_name {
            result["resume_file_name"] = resumeFileName
        }
        if let autoShareResume = self.auto_share_resume {
            result["auto_share_resume"] = autoShareResume
        }
        if let autoShareLinkedIn = self.auto_share_linkedIn {
            result["auto_share_linkedIn"] = autoShareLinkedIn
        }
        return result

    }
}

public enum ProfileModel: InteractiveModelType {
    
    public struct Request: Codable {
        public var about : String?
        public var phone : String?
        public var resume_url : String?
        public var linkedIn_url : String?
        public var job_title : String?
        public var has_work_permit: Bool?
        public var tos_accepted: Bool?
        public var resume_file_name : String?
        public var auto_share_resume: Bool?
        public var auto_share_linkedIn: Bool?
        
        public init(about: String?,linkedin: String?,jobTitle: String?,shareResume: Bool?,shareLinkedin: Bool?,resumeUrl: String? = nil,resumeFileName: String? = nil){
            self.about = about
            self.resume_url = resumeUrl
            self.job_title = jobTitle
            self.linkedIn_url = linkedin
            self.resume_file_name = resumeFileName
            self.auto_share_resume = shareResume
            self.auto_share_linkedIn = shareLinkedin
        }
    }
    
    public struct Response: Codable {
        public var name : String?
        public var job_title : String?
        public var email: String?
        public var phone: String?
        public var avatar_url: String?
        public var resume_url: String?
        public var linkedIn_url: String?
        public var resume_file_name: String?
        public var about: String?
        public var is_new: Bool?
        public var auto_share_resume: Bool?
        public var auto_share_linkedIn: Bool?
    }
}
