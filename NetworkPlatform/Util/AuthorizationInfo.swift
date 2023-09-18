//
//  AuthorizationInfo.swift
//  NetworkPlatform
//
//  Created by Ashkan Ghaderi on 7/22/20.
//  Copyright © 2020 myDigiPay. All rights reserved.
//

import Foundation
import KeychainAccess
import Domain
import Alamofire

enum RequestTimeoutInterval: Double {
    case long        = 30.0
    case `default`    = 15.0
    case fast        = 5.0
}

func refreshToken(){
    
}

public typealias RefreshTokenCompletion = (_ succeeded: Bool, _ accessToken: String?, _ refreshToken: String?) -> Void

public class AuthorizationInfo {
    
    public static weak var sessionManager: Alamofire.SessionManager? = { manager in
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = RequestTimeoutInterval.default.rawValue
        configuration.timeoutIntervalForResource = RequestTimeoutInterval.default.rawValue
        configuration.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        
        manager.retrier = AuthenticationRetries(baseURLString: BaseURL.dev.rawValue)
        manager.adapter = (manager.retrier as! RequestAdapter)
        return manager
    }(Alamofire.SessionManager.default)
    
    public static var refreshCompletion : RefreshTokenCompletion?
    
    public static var retryCount: Int! = 0;
    
    public static func isAuth() -> Bool{
        let keychain = Keychain(service: "com.Elinium.MondayJobs")
        if keychain["jwtToken"] != nil{
            return true
        } else{
            return false
        }
    }
    
    public static func isAllowToContinue(message: String?) -> Bool {
        let keychain = Keychain(service: "com.Elinium.MondayJobs")
        if (message != nil) {
            if message == "forbiden" || keychain["jwtToken"] == nil || message == "unauthorized" {
                
                return false
            }
            
        }
        return true
    }
    
    public static func isNetworkAvailable() -> Bool{
        
        return EasyReachability.isConnectedToNetwork()
        
    }
    
    public static func getRefreshToken()->String?{
        let keychain = Keychain(service: "com.Elinium.MondayJobs")
        return keychain["accessToken"]
    }
    
    public static func save(_ value:String?,key:String){
        let keychain = Keychain(service: "com.Elinium.MondayJobs")
        keychain[key] = value
    }
    
    public static func saveToken(data: AttendeeRegisterModel.Response){
        let keychain = Keychain(service: "com.Elinium.MondayJobs")
        keychain["jwtToken"] = data.jwt_token
        refreshCompletion?(isAuth(),data.access_token,data.jwt_token)
    }
    
    public static func saveData(data: AttendeeRegisterModel.Response){
        let keychain = Keychain(service: "com.Elinium.MondayJobs")
        keychain["jwtToken"] = data.jwt_token
        keychain["accessToken"] = data.access_token
        keychain["avatarUrl"] = data.avatar_url
        keychain["about"] = data.about
        keychain["email"] = data.email
        keychain["name"] = data.name
        
        
    }
    
    public static func saveData(data: LoginModel.Response){
        let keychain = Keychain(service: "com.Elinium.MondayJobs")
        keychain["jwtToken"] = data.jwt_token
        keychain["accessToken"] = data.access_token
        keychain["avatarUrl"] = data.avatar_url
        keychain["about"] = data.about
        keychain["email"] = data.email
        keychain["name"] = data.name
        
    }
    
    
    public static func remove(by key:String){
        let keychain = Keychain(service: "com.Elinium.MondayJobs")
        try? keychain.remove(key)
    }
    
    public static func get(by key: String)->String?{
        let keychain = Keychain(service: "com.Elinium.MondayJobs")
        return keychain[key]
        
    }
    
    public static func clearAuth(){
        do {
            let keychain = Keychain(service: "com.Elinium.MondayJobs")
            try keychain.removeAll()
        } catch {
            print("error on clear creditionals")
        }
    }
    
}

