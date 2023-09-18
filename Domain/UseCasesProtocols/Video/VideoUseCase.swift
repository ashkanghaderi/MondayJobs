//
//  VideoUseCase.swift
//  Domain
//
//  Created by Ashkan Ghaderi on 1/10/21.
//  Copyright © 2021 Elinium. All rights reserved.
//

import Foundation
import RxSwift

public protocol VideoUseCase {
    func roomInit() -> Observable<VideoModel>
    func roomClose() -> Observable<String>
    func roomJoin(agentId: String) -> Observable<VideoModel>
    func roomLeft() -> Observable<Bool>
}
