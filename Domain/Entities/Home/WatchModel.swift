//
//  WatchModel.swift
//  Domain
//
//  Created by Ashkan Ghaderi on 1/18/21.
//  Copyright © 2021 Elinium. All rights reserved.
//

import Foundation
public struct WatchModel : Codable{
    
    public var id: String?
    public var is_active: Bool?
    public var update_time: String?
    public var create_time: String?
    public var exhibition_id: String?
    public var panel_id: String?
    public var company_id: String?
    public var company_name: String?
    public var topic_name: String?
    public var logo_url: String?
    public var max_agents: Int?
    public var job_titles: [String]?
    public var available_agents_avatars: [String]?
      
}
