//
//  CompanyModel.swift
//  MondayJobs
//
//  Created by Ashkan Ghaderi on 11/13/20.
//  Copyright © 2020 Elinium. All rights reserved.
//

import Foundation
import Domain

public struct PanelModel {
    
    var id : String?
    var exhibitionId : String?
    var hallId : String?
    var bgColor : String?
    var icon : String?
    var isAvailable : Bool?
    var companyId : String?
    var companyName : String?
    var companyDesc : String?
    var logoUrl : String?
    var bgImg : String?
    var paymentStatus : String?
    var availableAgentsSize: Int?
    var agentImageList: [String]?
    var jobTitles : [String]?
    
    
    public init(_ panel: Domain.PanelModel){
        self.id = panel.id
        self.exhibitionId = panel.exhibition_id
        self.hallId = panel.hall_id
        self.bgColor = panel.bg_color
        self.icon = panel.icon
        self.isAvailable = panel.is_available
        self.companyId = panel.company_id
        self.icon = panel.icon
        self.companyName = panel.company_name
        self.logoUrl = panel.logo_url
        self.bgImg = panel.bg_img
        self.paymentStatus = panel.payment_status
        self.availableAgentsSize = panel.available_agents_size
        self.agentImageList = panel.available_agents_avatars
        self.jobTitles = panel.job_titles
    }
}
