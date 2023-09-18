////
////  OAuthInterceptor.swift
////  NetworkPlatform
////
////  Created by Ashkan Ghaderi on 10/16/20.
////  Copyright © 2020 Elinium. All rights reserved.
////
//
//import Foundation
//import Alamofire
//import Domain
//
//class OAuthInterceptor: RequestInterceptor {
//    private var baseURLString: String
//    public var accessToken: String?{
//        return AuthorizationInfo.get(by: "jwtToken")
//    }
//
//    private typealias RefreshCompletion = (_ succeeded: Bool, _ accessToken: String?, _ jwtToken: String?) -> Void
//
//    private let lock = NSLock()
//
//    private var isRefreshing = false
//
//    typealias AdapterResult = Swift.Result<URLRequest, Error>
//
//    // MARK: - Initialization
//
//    public init(baseURLString: String) {
//        self.baseURLString = baseURLString
//    }
//
//    // MARK: - RequestAdapter
//    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (AdapterResult) -> Void) {
//        //completion(.success(urlRequest))
//        if let urlString = urlRequest.url?.absoluteString, urlString.hasPrefix(baseURLString) {
//            var adaptedRequest = urlRequest
//
//            if let sToken = accessToken {
//                adaptedRequest.setValue("Bearer \(sToken)", forHTTPHeaderField: "Authorization")
//                print("🔑 >> AuthToken appended: \(urlString)")
//            }else{
//                print("🔑❌ >> No Token appended: \(urlString)")
//            }
//            completion(.success(adaptedRequest))
//        }
//        completion(.success(urlRequest))
//
//    }
//
//    // MARK: - RequestRetrier
//
//    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
//
//
//
//        if let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 {
//            if !isRefreshing {
//                refreshTokens(session: session) { [weak self] succeeded, accessToken, refreshToken in
//                    guard let strongSelf = self else { return }
//
//                    strongSelf.lock.lock() ; defer { strongSelf.lock.unlock() }
//
//                    if let refreshToken = refreshToken {
//                        AuthorizationInfo.save("jwtToken", key: refreshToken)
//                    }
//
//                    completion(.retry)
//                }
//            }
//        } else {
//            completion(.doNotRetry)
//        }
//    }
//
//     private func refreshTokens(session: Session,completion: @escaping RefreshCompletion) {
//
//            guard !isRefreshing else { return }
//
//            isRefreshing = true
//
//
//        let urlString = "\(self.baseURLString)/api/\(AppSetting.API_VERSION)/Attendees/refreshtoken"
//
//            let headerArray: HTTPHeaders = [HTTPHeader(name: "access_token", value: AuthorizationInfo.get(by: "accessToken") ?? ""),
//                HTTPHeader(name: "app_id", value: AppSetting.APP_ID)
//            ]
//
//            AF.request(urlString, method: .get, encoding: JSONEncoding.default, headers : headerArray)
//                .responseJSON { [weak self] response in
//                    guard let strongSelf = self else { return }
//
//                    if
//                        let json = response.value as? [String: Any],
//                        let jwtToken = json["jwt_token"] as? String
//                    {
//                        completion(true, nil, jwtToken)
//                    } else {
//                        completion(false, nil, nil)
//                    }
//
//                    strongSelf.isRefreshing = false
//                }
//        }
//
//
//
//}
