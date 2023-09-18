//
//  WatchModel.swift
//  MondayJobs
//
//  Created by Ashkan Ghaderi on 1/18/21.
//  Copyright © 2021 Elinium. All rights reserved.
//

import Foundation
import Domain

public struct WatchModel {
    
    public var id: String?
    public var isActive: Bool?
    public var updateTime: String?
    public var createTime: String?
    public var exhibitionId: String?
    public var panelId: String?
    public var companyId: String?
    public var companyName: String?
    public var topicName: String?
    public var logoUrl: String?
    public var maxAgents: Int?
    public var jobTitles: [String]?
    public var availableAgentsAvatars: [String]?
    
    public init(_ model: Domain.WatchModel){
        
        self.id = model.id
        self.isActive = model.is_active
        self.updateTime = model.update_time
        self.createTime = model.create_time
        self.exhibitionId = model.exhibition_id
        self.panelId = model.panel_id
        self.companyId = model.company_id
        self.companyName = model.company_name
        self.topicName = model.topic_name
        self.logoUrl = model.logo_url
        self.maxAgents = model.max_agents
        self.jobTitles = model.job_titles
        self.availableAgentsAvatars = model.available_agents_avatars
        
    }
      
}
