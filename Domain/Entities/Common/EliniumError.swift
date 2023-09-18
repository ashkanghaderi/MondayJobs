//
//  EliniumError.swift
//  Domain
//
//  Created by Ashkan Ghaderi on 11/5/20.
//  Copyright © 2020 Elinium. All rights reserved.
//

import Foundation
public enum EliniumError: LocalizedError {
    
    case failure(message: String?)
    case unknownMessage

    public var localization: String {
        switch self {
        case .failure(let message):
            if let msg = message {
                return msg
            }
            return ""
        case .unknownMessage:
            return ""
        }
    }
    
    static func  getError(err: Error) -> EliniumError  {
        return .unknownMessage
    }
}
