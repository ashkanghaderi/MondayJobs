//
//  CompanyModel.swift
//  MondayJobs
//
//  Created by Ashkan Ghaderi on 12/25/20.
//  Copyright © 2020 Elinium. All rights reserved.
//

import Foundation
import Domain

public struct CompanyModel {

    public var id : String?
    public var name : String?
    public var website : String?
    public var address : String?
    public var phone : String?
    public var postalCode : String?
    public var logoUrl : String?
    public var size : String?
    public var fieldOfActivity : String?
    public var aboutEn : String?
    public var aboutFr : String?
    public var panelId : String?
    public var mapIcon : String?
    public var paymentStatus : String?
    public var jobTitles : [String]?
    public var availableAgentsAvatars : [String]?
    public var jobs: [JobItemModel]?
    public var agents: [AgentModel]?
    
    
    public init(_ company : Domain.CompanyModel.Response){
        id = company.id
        name = company.name
        website = company.website
        address = company.address
        phone = company.phone
        postalCode = company.postal_code
        logoUrl = company.logo_url
        size = company.size
        fieldOfActivity = company.field_of_activity
        aboutEn = company.about_en
        aboutFr = company.about_fr
        panelId = company.panel_id
        mapIcon = company.map_icon
        paymentStatus = company.payment_status
        jobTitles = company.job_titles
        availableAgentsAvatars = company.available_agents_avatars
        jobs = company.jobs?.compactMap({(job) -> JobItemModel in
            return JobItemModel(job)
        })
        agents = company.agents?.compactMap({(agent) -> AgentModel in
            return AgentModel(agent)
        })
    }
}

public struct JobItemModel {
    
    public var id : String?
    public var isActive : Bool?
    public var companyId : String?
    public var titleEn : String?
    public var titleFr : String?
    public var descriptionEn : String?
    public var descriptionFr : String?
    
    public init(_ job : Domain.JobItemModel){
        id = job.id
        isActive = job.is_active
        companyId = job.company_id
        titleEn = job.title_en
        titleFr = job.title_fr
        descriptionEn = job.description_en
        descriptionFr = job.description_fr
    }
}

public struct AgentModel{
    public var id : String?
    public var isActiveAgent : Bool?
    public var name : String?
    public var email : String?
    public var phone : String?
    public var position : String?
    public var avatarUrl : String?
    public var roomId : String?
    public var showPhone  : Bool?
    public var showPosition : Bool?
    public var jwtToken : String?
    public var isActive : Bool?
    public var jobs : [JobItemModel]?
    
    public init(_ agent : Domain.AgentModel){
        id = agent.id
        isActiveAgent = agent.is_active_agent
        name = agent.name
        email = agent.email
        phone = agent.phone
        position = agent.position
        avatarUrl = agent.avatar_url
        roomId = agent.room_id
        showPhone = agent.show_phone
        showPosition = agent.show_position
        jwtToken = agent.jwt_token
        isActive = agent.is_active
        jobs = agent.jobs?.compactMap({(job) -> JobItemModel in
            return JobItemModel(job)
        })
    }
}
