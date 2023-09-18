//
//  CustomError.swift
//  Domain
//
//  Created by Ashkan Ghaderi on 11/5/20.
//  Copyright © 2020 Elinium. All rights reserved.
//

import Foundation
public struct CustomError : Decodable{
    public let error_no: Int?
    public let error_code: String?
    public let display_message: String?
    public let error_msg: String?
}
