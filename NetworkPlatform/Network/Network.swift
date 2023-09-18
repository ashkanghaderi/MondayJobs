//
//  Wrapable.swift
//  NetworkPlatform
//
//  Created by Ashkan Ghaderi on 10/26/20.
//  Copyright © 2020 Elinium. All rights reserved.
//

import Domain
import Alamofire
import RxSwift


public class Network {
    
    private let endPoint: String
    private let scheduler: ConcurrentDispatchQueueScheduler
    private var tokenString: String {
        return "Bearer " + (AuthorizationInfo.get(by: "jwtToken") ?? "")
    }
    private var sharedHeaders: HTTPHeaders{
        return ["Content-Type": "application/json", "language": Locale.current.languageCode ?? "en","Authorization": tokenString]
    }
    
    let disposeBag = DisposeBag()
    init(_ endPoint: String) {
        self.endPoint = endPoint
        self.scheduler = ConcurrentDispatchQueueScheduler(qos: DispatchQoS(qosClass: DispatchQoS.QoSClass.background, relativePriority: 1))
    }
    
    func getItems<T: Codable>(_ path: String, itemId: String = "") -> Observable<[T]> {
        let absolutePath = itemId == "" ? endPoint + path : endPoint + "\(path)?\(itemId)"
        
        print(">>> Service : " ,absolutePath )
        return Observable<[T]>.create { observer in
            AuthorizationInfo.sessionManager?.request(absolutePath,
                                                     method: .get,
                                                     headers: self.sharedHeaders)
                .validate()
                .responseJSON { (response) in
                    let decoder = JSONDecoder()
                    switch response.result {
                    case .success:
                        if let data = response.data {
                            
                            if let value = try? decoder.decode([T].self, from: data) {
                                
                                observer.onNext(value)
                                observer.onCompleted()
                                print("success",value)
                            }
                            
                        }
                    case .failure(let error):
                        
                        if let data = response.data {
                            
                            if let value = try? decoder.decode(CustomError.self, from: data) {
                                
                                observer.onError(EliniumError.failure(message: value.display_message))
                                
                                print("failure",value)
                            }
                            
                        }
                        observer.onError(EliniumError.failure(message: error.localizedDescription))
                        print("failure",error)
                    }
                }
            return Disposables.create()
        }
        
        
    }
    
    func getItem<T: Codable>(_ path: String, itemId: String = "") -> Observable<T> {
        let absolutePath = itemId == "" ? endPoint + path : endPoint + "\(path)?\(itemId)"
        
        print(">>> Service : " ,absolutePath )
        return Observable<T>.create { observer in
            AuthorizationInfo.sessionManager?.request(absolutePath,
                                                     method: .get,
                                                     headers: self.sharedHeaders)
                .validate()
                .responseJSON { (response) in
                    let decoder = JSONDecoder()
                    switch response.result {
                    case .success:
                        if let data = response.data {
                            
                            if let value = try? decoder.decode(T.self, from: data) {
                                
                                observer.onNext(value)
                                observer.onCompleted()
                                print("success",value)
                            }
                            
                        }
                    case .failure(let error):
                        
                        if let data = response.data {
                            
                            if let value = try? decoder.decode(CustomError.self, from: data) {
                                
                                observer.onError(EliniumError.failure(message: value.display_message))
                                
                                print("failure",value)
                            }
                            
                        }
                        observer.onError(EliniumError.failure(message: error.localizedDescription))
                    }
                }
            return Disposables.create()
        }
        
    }
    
    func deleteItem<T: Codable>(_ path: String, itemId: String = "") -> Observable<T> {
        let absolutePath = itemId == "" ? endPoint + path : endPoint + "\(path)?\(itemId)"
        
        print(">>> Service : " ,absolutePath )
        return Observable<T>.create { observer in
            AuthorizationInfo.sessionManager?.request(absolutePath,
                                                     method: .delete,
                                                     headers: self.sharedHeaders)
                .validate()
                .responseJSON { (response) in
                    let decoder = JSONDecoder()
                    switch response.result {
                    case .success:
                        if let data = response.data {
                            
                            if let value = try? decoder.decode(T.self, from: data) {
                                
                                observer.onNext(value)
                                observer.onCompleted()
                                print("success",value)
                            }
                            
                        }
                    case .failure(let error):
                        
                        if let data = response.data {
                            
                            if let value = try? decoder.decode(CustomError.self, from: data) {
                                
                                observer.onError(EliniumError.failure(message: value.display_message))
                                
                                print("failure",value)
                            }
                            
                        }
                        observer.onError(EliniumError.failure(message: error.localizedDescription))
                    }
                }
            return Disposables.create()
        }
        
    }
    
    func postItem<T: Decodable>(url: String,
                                param: Parameters? = nil,
                                method: HTTPMethod = .post,
                                encoding: ParameterEncoding = JSONEncoding.default) -> Observable<T> {
        
        
        let absolutePath = endPoint + url
        print(">>> Service : " ,absolutePath , ":::" ,param as Any)
        return Observable<T>.create { observer in
            AuthorizationInfo.sessionManager?.request(absolutePath,
                                                     method: .post,
                                                     parameters: param,
                                                     encoding: encoding,
                                                     headers: self.sharedHeaders)
                .validate()
                .responseJSON { (response) in
                    let decoder = JSONDecoder()
                    switch response.result {
                    case .success:
                        if let data = response.data {
                            
                            if let value = try? decoder.decode(T.self, from: data) {
                                
                                observer.onNext(value)
                                observer.onCompleted()
                                print("success",value)
                            }
                            
                        }
                    case .failure(let error):
                        
                        if let data = response.data {
                            
                            if let value = try? decoder.decode(CustomError.self, from: data) {
                                
                                observer.onError(EliniumError.failure(message: value.display_message))
                                
                                print("failure",value)
                            }
                            
                        }
                        observer.onError(EliniumError.failure(message: error.localizedDescription))
                        print("failure",error)
                    }  
                }
            return Disposables.create()
        }
    }
    
    
    func putItem<T: Codable>(_ path: String, param: [String: Any],
                             encoding: ParameterEncoding = JSONEncoding.default) -> Observable<T> {
        let absolutePath = endPoint + path
        print("PUT: \non: \(absolutePath)\nparameters: \(param)")
        
        print(">>> Service : " ,absolutePath , ":::" ,param as Any)
        return Observable<T>.create { observer in
            AuthorizationInfo.sessionManager?.request(absolutePath,
                                                     method: .put,
                                                     parameters: param,
                                                     encoding: encoding,
                                                     headers: self.sharedHeaders)
                .validate()
                .responseJSON { (response) in
                    let decoder = JSONDecoder()
                    switch response.result {
                    case .success:
                        if let data = response.data {
                            
                            if let value = try? decoder.decode(T.self, from: data) {
                                
                                observer.onNext(value)
                                observer.onCompleted()
                                print("success",value)
                            }
                            
                        }
                    case .failure(let error):
                        
                        if let data = response.data {
                            
                            if let value = try? decoder.decode(CustomError.self, from: data) {
                                
                                observer.onError(EliniumError.failure(message: value.display_message))
                                
                                print("failure",value)
                            }
                            
                        }
                        observer.onError(EliniumError.failure(message: error.localizedDescription))
                        print("failure",error)
                    }
                }
            return Disposables.create()
        }
    }
    
    func postItems<T: Codable>(_ path: String, param: [String: Any],
                               encoding: ParameterEncoding = JSONEncoding.default) -> Observable<[T]> {
        
        let absolutePath = endPoint + path
        print(">>> Service : " ,absolutePath , ":::" ,param as Any)
        return Observable<[T]>.create { observer in
            AuthorizationInfo.sessionManager?.request(absolutePath,
                                                     method: .post,
                                                     parameters: param,
                                                     encoding: encoding,
                                                     headers: self.sharedHeaders)
                .validate()
                .responseJSON { (response) in
                    let decoder = JSONDecoder()
                    switch response.result {
                    case .success:
                        if let data = response.data {
                            
                            if let value = try? decoder.decode([T].self, from: data) {
                                
                                observer.onNext(value)
                                observer.onCompleted()
                                print("success",value)
                            }
                            
                        }
                    case .failure(let error):
                        
                        if let data = response.data {
                            
                            if let value = try? decoder.decode(CustomError.self, from: data) {
                                
                                observer.onError(EliniumError.failure(message: value.display_message))
                                
                                print("failure",value)
                            }
                            
                        }
                        observer.onError(EliniumError.failure(message: error.localizedDescription))
                        print("failure",error)
                    }
                }
            return Disposables.create()
        }
    }
    
    func uploadFile<T: Codable>(file: Data?,url: String,
                                param: [String: Any]? = nil,fileType: FileTypeEnum) -> Observable<T>{
        let absolutePath = endPoint + url
        
        let headers = ["Content-Type": "multipart/form-data", "language": Locale.current.languageCode ?? "en","Authorization": tokenString]
        
        return Observable<T>.create { observer in
            AuthorizationInfo.sessionManager?.upload(multipartFormData: { (multipartFormData) in
                if let uploadFile = file {
                    switch fileType {
                    case .jpg:
                        multipartFormData.append(uploadFile, withName: "file",fileName: "file.jpg", mimeType: fileType.rawValue)
                    case .png:
                        multipartFormData.append(uploadFile, withName: "file",fileName: "file.png", mimeType: fileType.rawValue)
                    case .pdf:
                        multipartFormData.append(uploadFile, withName: "file",fileName: "file.pdf", mimeType: fileType.rawValue)
                    
                    }
                   
                }
                
                if let params = param {
                    for (key, value) in params {
                        if let paramValue = value as? String,
                           let data = paramValue.data(using: .utf8) {
                            multipartFormData.append(data , withName: key)
                        }
                    }
                }
            }, to: absolutePath,
            method: .post,
            headers: headers)
            { (result) in
                switch result {
                case .success(let upload, _, _):
                    let decoder = JSONDecoder()
                    upload.uploadProgress(closure: { (progress) in
                        print("Upload Progress: \(progress.fractionCompleted)")
                    })
                    
                    upload.responseJSON { response in
                        
                        if let data = response.data {
                            
                            if let value = try? decoder.decode(T.self, from: data) {
                                
                                observer.onNext(value)
                                observer.onCompleted()
                                print("success",value)
                            }
                            
                        }
                    }
                    
                    
                case .failure(let encodingError):
                    
                    observer.onError(EliniumError.failure(message: encodingError.localizedDescription))
                    print("failure",encodingError)
                }
            }
            
            return Disposables.create()
        }
    }
    
    func handle(error: Error, data: Data, StatusCode code: Int) -> NSError {
        ResponseAnalytics.printError(status: code, error: error)
        do {
            let responseError = try JSONDecoder().decode(ResponseMessage.Base.self, from: data)
            
            return NSError(domain: ErrorTypes.externalError.rawValue, code: code, userInfo: ["responseError": responseError])
        }catch{
            return NSError(domain: ErrorTypes.internalError.rawValue, code: code, userInfo: ["data" : data])
        }
    }
    
    func handle(data: Data, StatusCode code: Int) -> NSError {
        do {
            let responseError = try JSONDecoder().decode(ResponseMessage.Base.self, from: data)
            
            return NSError(domain: ErrorTypes.externalError.rawValue, code: code, userInfo: ["responseError": responseError])
        }catch{
            return NSError(domain: ErrorTypes.internalError.rawValue, code: code, userInfo: ["data" : data])
        }
    }
}
