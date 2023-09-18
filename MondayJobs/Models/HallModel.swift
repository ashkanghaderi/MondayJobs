//
//  HallModel.swift
//  MondayJobs
//
//  Created by Ashkan Ghaderi on 11/14/20.
//  Copyright © 2020 Elinium. All rights reserved.
//

import Foundation
import Domain

public struct HallModel {
    
    var id : String?
    var name : String?
    var exhibitionId : String?
    var isActive : Bool?
    var panels: [PanelModel]
    
    
    public init(_ hall: Domain.HallModel){
        self.id = hall.id
        self.name = hall.name
        self.exhibitionId = hall.exhibition_id
        self.isActive = hall.is_active
        self.panels = hall.panels.map({(panel) -> PanelModel in
            return PanelModel(panel)
        })
    }
}
