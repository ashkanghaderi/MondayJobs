//
//  HomeCardsServices.swift
//  NetworkPlatform
//
//  Created by Ashkan Ghaderi on 8/8/20.
//  Copyright © 2020 Elinium. All rights reserved.
//

import Foundation
import RxSwift
import Domain

public final class HomeService{
    
    private let network: Network
    
    init(network: Network) {
        self.network = network
    }
    
    public func fetchExhibition() -> Observable<ExhibitionModel.Response>{
        let url = ServiceRouter.ExhibitionServiceRoute(.current).url
        let query = "include_halls=\(true)"
        return network.getItem(url,itemId: query)
    }
    
    public func searchExhibition(query: String) -> Observable<[PanelModel]>{
        let url = ServiceRouter.ExhibitionServiceRoute(.search).url
        let queryStr = "text=\(query)&company=\(query)&industry=\(query)"
        return network.getItems(url,itemId: queryStr)
    }
    
    public func fetchWatchList() -> Observable<[WatchModel]>{
        let url = ServiceRouter.ExhibitionServiceRoute(.watchList).url
        return network.getItems(url)
    }
    
    public func setWatch(companyId: String) -> Observable<WatchModel>{
        let url = ServiceRouter.ExhibitionServiceRoute(.watch).url
        let queryStr = "?company=\(companyId)"
        return network.postItem(url: url+queryStr)
    }
    
    public func deleteWatch(companyId: String) -> Observable<WatchModel>{
        let url = ServiceRouter.ExhibitionServiceRoute(.watch).url
        let queryStr = "company=\(companyId)"
        return network.deleteItem(url,itemId: queryStr)
    }
}
