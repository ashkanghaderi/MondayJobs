//
//  AuthenticationStatus.swift
//  Domain
//
//  Created by Ashkan Ghaderi on 8/8/20.
//  Copyright © 2020 Elinium. All rights reserved.
//

import Foundation

public enum AuthenticationStatus: Int {
  case notDetermined = -1
  case tokenExpired = -2
  case loggedIn = 1
}

