//
//  AuthenticationRetries.swift
//  NetworkPlatform
//
//  Created by Ashkan Ghaderi on 1/7/21.
//  Copyright © 2021 Elinium. All rights reserved.
//

import Foundation
import Alamofire
import Domain

class AuthenticationRetries: RequestRetrier, RequestAdapter {
    
    private var baseURLString: String
    private let authenticationHeaderName = "Authorization"
    
    private typealias RefreshCompletion = (_ succeeded: Bool, _ accessToken: String?, _ jwtToken: String?) -> Void
    
    private let lock = NSLock()
    
    public init(baseURLString: String) {
        self.baseURLString = baseURLString
    }
    
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        
        
        if (urlRequest.url?.absoluteString) != nil {
            
            // return original urlRequest if authentication header contain basic token hash
            if let authenticationHeader = urlRequest.value(forHTTPHeaderField: authenticationHeaderName),
               authenticationHeader.contains(AppSetting.BASIC_TOKEN_HASH) {
                return urlRequest
            }
            
            var urlRequest = urlRequest
            
            // apply jwt token authentication
            if let token = AuthorizationInfo.get(by: "jwtToken") {
                // modified authentication header value
                urlRequest.setValue("Bearer " + token , forHTTPHeaderField: authenticationHeaderName)
            }
            
            return urlRequest
        }
        
        return urlRequest
    }
    
    
    var shouldAdaptRequest : Bool = false
    var isRefreshing : Bool = false
    
    var requestsToRetry : [RequestRetryCompletion] = []
    
    #if !RELEASE
    var requestsURLToRetry : [String?] = []
    #endif
    
    func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
        
        
        lock.lock() ; defer { lock.unlock() }
        
        #if DEBUG || Staging
        requestsURLToRetry.append(request.request?.url?.absoluteString)
        #endif
        
        
        if let response = request.task?.response as? HTTPURLResponse {
            
            switch response.statusCode {
            case 401:
                
                self.unauthorizationRetry(retry: request, completion: completion)
                return
            case 403:
                //TODO: Show Login View
                //showLoginView()
                
                completion(false,0.0)
            default:
                completion(false,0.0)
                break
            }
            
        }
        else {
            completion(false,0.0)
        }
        
    }
    
    
    //    func showLoginView() {
    //
    //        let block = {
    //            Authentication.loginAgain(message: Message(title: "پس از ورود، مجددا تلاش کنید"))
    //        }
    //
    //        if Thread.isMainThread {
    //            block()
    //        }else{
    //            DispatchQueue.main.async(execute: block)
    //        }
    //    }
    
    private func unauthorizationRetry(retry request: Request, completion: @escaping RequestRetryCompletion) {
        
        guard request.retryCount < 3 else {
            
            self.lock.lock() ; defer { self.lock.unlock() }
            // showLoginView()
            self.requestsToRetry.forEach({ $0(false,0) })
            self.requestsToRetry.removeAll()
            
            completion(false,0)
            return
        }
        
        requestsToRetry.append(completion)
        
        if !isRefreshing {
            isRefreshing = true
            AuthorizationInfo.refreshCompletion = {[weak self] (success, accessToken, refreshToken) in
                
                guard let `self` = self else { return }
                self.lock.lock() ; defer { self.lock.unlock() }
                
            
                // execture all completion
                self.requestsToRetry.forEach({ $0(success,0) })
                self.requestsToRetry.removeAll()
                
                // reset evertything
                self.isRefreshing = false
                AuthorizationInfo.refreshCompletion = nil
                AuthorizationInfo.retryCount = 0
            }
            
            refreshTokens()
        }
        
    }
    
    
    private func refreshTokens() {
        
        let urlString = "\(self.baseURLString)/api/\(AppSetting.API_VERSION)/Attendees/refreshtoken"
        
        let headerArray: HTTPHeaders = [ "access_token":AuthorizationInfo.get(by: "accessToken") ?? "",
                                         "app_id": AppSetting.APP_ID]
        
        
        Alamofire.request(urlString, method: .get, encoding: JSONEncoding.default, headers : headerArray)
            .responseJSON { [weak self] response in
                guard let strongSelf = self else { return }
                
                let decoder = JSONDecoder()
                switch response.result {
                case .success:
                    if let data = response.data {

                        if let value = try? decoder.decode(AttendeeRegisterModel.Response.self, from: data) {
                            
                            AuthorizationInfo.saveToken(data: value)
                            print("success",value)
                        }
                        
                    }
                case .failure(let error):
                    
                    if let data = response.data {

                        if let value = try? decoder.decode(CustomError.self, from: data) {
                            
                           
                            
                            print("failure",value)
                        }
                        
                    }
                    
                }
                
                
                strongSelf.isRefreshing = false
            }
    }
    
}


