//
//  VideoService.swift
//  NetworkPlatform
//
//  Created by Ashkan Ghaderi on 1/11/21.
//  Copyright © 2021 Elinium. All rights reserved.
//

import Foundation
import RxSwift
import Domain

public final class VideoService{
    
    private let network: Network
    
    init(network: Network) {
        self.network = network
    }
    
    public func roomInit() -> Observable<VideoModel> {
        
        let url = ServiceRouter.VideoServiceRoute(.VideoInit).url

        return network.getItem(url)
    }
    
    public func roomClose() -> Observable<String> {
        
        let url = ServiceRouter.VideoServiceRoute(.close).url

        return network.getItem(url)
    }
    
    public func roomJoin(agentId: String) -> Observable<VideoModel> {
        
        let url = ServiceRouter.VideoServiceRoute(.join).url
        let urlStr = url + agentId + "/participant_join"
        return network.getItem(urlStr)
    }
    
    public func roomLeft() -> Observable<Bool> {
        
        let url = ServiceRouter.VideoServiceRoute(.left).url

        return network.getItem(url)
    }
    
}
