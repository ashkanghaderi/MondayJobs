//
//  HomeUseCase.swift
//  Domain
//
//  Created by Ashkan Ghaderi on 8/8/20.
//  Copyright © 2020 Elinium. All rights reserved.
//

import Foundation
import RxSwift

public protocol HomeUseCase {
    func fetchExhibition() -> Observable<ExhibitionModel.Response>
    
    func searchExhibition(query: String) -> Observable<[PanelModel]>
    
    func fetchWatchList() -> Observable<[WatchModel]>
    
    func setWatch(companyId: String) -> Observable<WatchModel>
    
    func deleteWatch(companyId: String) -> Observable<WatchModel>
}
