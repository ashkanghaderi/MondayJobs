//
//  SuggesstionModel.swift
//  MondayJobs
//
//  Created by Ashkan Ghaderi on 11/14/20.
//  Copyright © 2020 Elinium. All rights reserved.
//

import Foundation
public struct SuggesstionModel {
    
    var icon : String?
    var companyName : String?
    var companyDesc : String?
    var salary : String?
    var jobTitle : String?
    
    
    public init(icon: String,companyName : String,companyDesc : String,salary : String,jobTitle : String){
        self.icon = icon
        self.companyName = companyName
        self.companyDesc = companyDesc
        self.salary = salary
        self.jobTitle = jobTitle
    }
    
    init() {
        
    }
}
