//
//  UploadFileModel.swift
//  Domain
//
//  Created by Ashkan Ghaderi on 1/14/21.
//  Copyright © 2021 Elinium. All rights reserved.
//

import Foundation

public struct UploadFileModel : Codable {
    
    public let id : String?

    public let update_time : String?

    public let mime_type : String?

    public let desc : String?

    public let url : String?

}
