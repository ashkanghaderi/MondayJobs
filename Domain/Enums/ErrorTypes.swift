//
//  ErrorTypes.swift
//  Domain
//
//  Created by Ashkan Ghaderi on 8/8/20.
//  Copyright © 2020 Elinium. All rights reserved.
//

import Foundation

public enum InternalErrorCodes: Int {
  case jsonParsingError = -10024
}

public enum ErrorTypes: String{
  case internalError = "InternalError"
  case externalError = "ExternalError"
}

public enum ProviderTypes: String{
  case google = "google"
  case linkedin = "linkedin"
}

