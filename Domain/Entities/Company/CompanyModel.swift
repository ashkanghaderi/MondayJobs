//
//  CompanyModel.swift
//  Domain
//
//  Created by Ashkan Ghaderi on 12/25/20.
//  Copyright © 2020 Elinium. All rights reserved.
//

import Foundation

public enum CompanyModel: InteractiveModelType {
    
    public struct Request: Codable {
       
    }
    
    public struct Response: Codable {
        public var id : String?
        public var name : String?
        public var website : String?
        public var address : String?
        public var phone : String?
        public var postal_code : String?
        public var logo_url : String?
        public var size : String?
        public var field_of_activity : String?
        public var about_en : String?
        public var about_fr : String?
        public var panel_id : String?
        public var map_icon : String?
        public var payment_status : String?
        public var job_titles : [String]?
        public var available_agents_avatars : [String]?
        public var jobs: [JobItemModel]?
        public var agents: [AgentModel]?

    }
}

public struct JobItemModel : Codable {
    
    public var id : String?
    public var is_active : Bool?
    public var company_id : String?
    public var title_en : String?
    public var title_fr : String?
    public var description_en : String?
    public var description_fr : String?
}

public struct AgentModel : Codable {
    public var id : String?
    public var is_active_agent : Bool?
    public var name : String?
    public var email : String?
    public var phone : String?
    public var position : String?
    public var avatar_url : String?
    public var room_id : String?
    public var show_phone  : Bool?
    public var show_position : Bool?
    public var jwt_token : String?
    public var is_active : Bool?
    public var jobs : [JobItemModel]?
}

