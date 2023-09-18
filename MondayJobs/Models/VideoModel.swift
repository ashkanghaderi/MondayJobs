//
//  VideoModel.swift
//  MondayJobs
//
//  Created by Ashkan Ghaderi on 1/12/21.
//  Copyright © 2021 Elinium. All rights reserved.
//

import Foundation
import  Domain
public struct VideoModel  {
    public let room : String?
    public let token : String?
    
    init(_ model: Domain.VideoModel) {
        room = model.room
        token = model.token
    }
}


public struct VideoRoomModel  {
    public let agentId : String?
    public let agentName : String?
    public let agentPosition : String?
    public let roomName: String?
    
    public init(agentId : String?,agentName : String?,agentPosition : String?,roomName: String?){
        self.agentId = agentId
        self.agentName = agentName
        self.agentPosition = agentPosition
        self.roomName = roomName
    }
    
}
