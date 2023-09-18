//
//  ResponseMessage.swift
//  Domain
//
//  Created by Ashkan Ghaderi on 8/8/20.
//  Copyright © 2020 Elinium. All rights reserved.
//

protocol InteractiveModelType {
  associatedtype Request
  associatedtype Response
}

public enum ResponseMessage {
  public struct Base: Codable {
    public let code: Int
    public let message: String
  }
}
