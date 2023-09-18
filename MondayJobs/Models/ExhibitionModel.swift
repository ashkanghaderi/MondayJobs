//
//  ExhibitionModel.swift
//  MondayJobs
//
//  Created by Ashkan Ghaderi on 11/14/20.
//  Copyright © 2020 Elinium. All rights reserved.
//

import Foundation
import Domain

public struct ExhibitionModel {
    
    var id : String?
    var date : String?
    var isActive : Bool?
    var isCurrent : Bool?
    var isRunning : Bool?
    var companyRegisterOpen : Bool?
    var jobseekerRegisterOpen : Bool?
    var baseImgLayer : String?
    var halls: [HallModel]?
    
        
    public init(_ exhibition: Domain.ExhibitionModel.Response){
        
        self.id = exhibition.id
        self.date = exhibition.date
        self.isActive = exhibition.is_active
        self.isCurrent = exhibition.is_current
        self.isRunning = exhibition.is_running
        self.companyRegisterOpen = exhibition.company_register_open
        self.jobseekerRegisterOpen = exhibition.jobseeker_register_open
        self.baseImgLayer = exhibition.base_img_layer
        self.halls = exhibition.halls?.map({(hall) -> HallModel in
            return HallModel(hall)
        })
    }
    
}
