//
//  SoketManager.swift
//  MondayJobs
//
//  Created by Ashkan Ghaderi on 1/30/21.
//  Copyright © 2021 Elinium. All rights reserved.
//

import Foundation
import SwiftSignalRClient
import Domain
import NetworkPlatform

public class SoketManager{
    
    private var hubConnection: HubConnection?

    public static var shared = SoketManager()
    
    func connect() {
        
        let urlString: String = BaseURL.soket.rawValue + "?auth_token=" + (AuthorizationInfo.get(by: "jwtToken") ?? "")
        
        let url = URL(string: urlString)!
        hubConnection = HubConnectionBuilder(url: url)
            .withHubConnectionDelegate(delegate: self)
            .withAutoReconnect()
            .withLogging(minLogLevel: .debug)
            .build()
        
        hubConnection!.on(method: "CompanyAvailable", callback: { (data: String) in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CompanyAvailable"), object: data)
        })

        hubConnection!.start()
    }
    
    func closeConnection(){
        hubConnection?.stop()
    }
    
    func logMessage(messageText: String) {
        NSLog(messageText)
        print(messageText)
    }
}

extension SoketManager : HubConnectionDelegate {
   
    public func connectionDidOpen(hubConnection: HubConnection) {
        self.logMessage(messageText: "Connection started")
    }

    public func connectionDidFailToOpen(error: Error) {
        self.logMessage(messageText: "Fail To Open:->" + error.localizedDescription)
    }

    public func connectionDidClose(error: Error?) {
        self.logMessage(messageText: "Did Close")
    }

    public func connectionWillReconnect(error: Error) {
        self.logMessage(messageText: "Will Reconnect:->" + error.localizedDescription)
    }

    public func connectionDidReconnect() {
        self.logMessage(messageText: "Did Reconnected")
    }
}
