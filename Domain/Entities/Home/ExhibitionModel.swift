//
//  ExhibitionModel.swift
//  Domain
//
//  Created by Ashkan Ghaderi on 1/1/21.
//  Copyright © 2021 Elinium. All rights reserved.
//

import Foundation

public enum ExhibitionModel: InteractiveModelType {
    
    public struct Request: Codable {
       
    }
    
    public struct Response: Codable {
       
        public var id : String?
        public var date : String?
        public var is_active : Bool?
        public var is_current : Bool?
        public var is_running : Bool?
        public var company_register_open : Bool?
        public var jobseeker_register_open : Bool?
        public var base_img_layer : String?
        public var halls: [HallModel]?
    }
}

public struct PanelModel : Codable  {
    
    public var id : String?
    public var exhibition_id : String?
    public var hall_id : String?
    public var bg_color : String?
    public var icon : String?
    public var is_available : Bool?
    public var company_id : String?
    public var company_name : String?
    public var logo_url : String?
    public var bg_img : String?
    public var payment_status : String?
    public var job_titles : [String]?
    public var available_agents_size: Int?
    public var available_agents_avatars: [String]?
}

public struct HallModel : Codable  {
    
    public var id : String?
    public var name : String?
    public var exhibition_id : String?
    public var is_active : Bool?
    public var panels: [PanelModel]
    
}
