//
//  MenuModel.swift
//  MondayJobs
//
//  Created by Ashkan Ghaderi on 12/23/20.
//  Copyright © 2020 Elinium. All rights reserved.
//

import Foundation

final class MenuModel {
    
    var icon : String?
    var title : String?
    var isActive : Bool?
    
    
    public init(icon: String,title : String,isActive : Bool){
        self.icon = icon
        self.title = title
        self.isActive = isActive
    }
    
    init(){}

}
