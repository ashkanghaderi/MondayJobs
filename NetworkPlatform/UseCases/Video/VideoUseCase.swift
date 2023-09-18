//
//  VideoUseCase.swift
//  NetworkPlatform
//
//  Created by Ashkan Ghaderi on 1/11/21.
//  Copyright © 2021 Elinium. All rights reserved.
//

import Foundation
import Domain
import RxSwift
public final class VideoUseCase: Domain.VideoUseCase {
    
    @LazyInjected private var service: VideoService
    
    public init(){}
    
    public func roomInit() -> Observable<VideoModel> {
        return service.roomInit()
    }
    
    public func roomClose() -> Observable<String> {
        return service.roomClose()
    }
    
    public func roomJoin(agentId: String) -> Observable<VideoModel> {
        return service.roomJoin(agentId: agentId)
    }
    
    public func roomLeft() -> Observable<Bool> {
        return service.roomLeft()
    }
    

    
    
    
    
}
