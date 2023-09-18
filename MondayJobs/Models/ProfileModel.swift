//
//  ProfileModel.swift
//  MondayJobs
//
//  Created by Ashkan Ghaderi on 1/13/21.
//  Copyright © 2021 Elinium. All rights reserved.
//

import Foundation
import  Domain
public struct ProfileModel  {
    
    public var name : String?
    public var jobTitle : String?
    public var email: String?
    public var phone: String?
    public var avatarUrl: String?
    public var resumeUrl: String?
    public var linkedInUrl: String?
    public var about: String?
    public var isNew: Bool?
    public var resumeFileName: String?
    public var autoShareResume: Bool?
    public var autoShareLinkedIn: Bool?
    
    init(_ model: Domain.ProfileModel.Response) {
        name = model.name
        jobTitle = model.job_title
        email = model.email
        phone = model.phone
        avatarUrl = model.avatar_url
        resumeUrl = model.resume_url
        linkedInUrl = model.linkedIn_url
        about = model.about
        resumeFileName = model.resume_file_name
        autoShareResume = model.auto_share_resume
        autoShareLinkedIn = model.auto_share_linkedIn
        
    }
}

public struct UploadFileModel{
    public var type : FileTypeEnum?
    public var data : Data?
}

