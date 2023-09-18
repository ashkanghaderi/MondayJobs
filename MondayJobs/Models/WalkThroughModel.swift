//
//  WalkThroughModel.swift
//  MondayJobs
//
//  Created by Ashkan Ghaderi on 7/23/20.
//  Copyright © 2020 Elinium. All rights reserved.
//

import Foundation
import Domain

public struct WalkThroughModel {
    var uid : String?
    var title : String?
    var description : String?
    var imageId : String?
    var order : Int?

    public init(with response: Domain.WalkThrough){
        self.uid = response.uid
        self.title = response.title
        self.description = response.description ?? ""
        self.imageId = response.imageId ?? ""
        self.order = response.order
        
    }
    
    public init(title : String,description : String,imageId : String,order : Int){
        self.title = title
        self.description = description
        self.imageId = imageId
        self.order = order
    }
}
