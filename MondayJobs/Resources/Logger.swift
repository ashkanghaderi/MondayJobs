//
//  Logger.swift
//  MondayJobs
//
//  Created by Ashkan Ghaderi on 10/31/20.
//  Copyright © 2020 Elinium. All rights reserved.
//

import Foundation
import CocoaLumberjack.Swift

/// Logger Struct
struct Logger {
    
    
    static func debugLog(_ message:  @autoclosure () -> String,file: StaticString = #file, function: StaticString = #function, line: UInt = #line, tag: Any? = nil) {
        DDLogDebug(message(),file:file,function:function,line:line,tag:tag)
    }
    
    static func infoLog(_ message: @autoclosure () -> String,file: StaticString = #file, function: StaticString = #function, line: UInt = #line, tag: Any? = nil) {
        DDLogInfo(message(),file:file,function:function,line:line,tag:tag)
    }
    
    static func warnLog(_ message: @autoclosure () -> String,file: StaticString = #file, function: StaticString = #function, line: UInt = #line, tag: Any? = nil) {
        DDLogWarn(message(),file:file,function:function,line:line,tag:tag)
    }
    
    static func verboseLog(_ message: @autoclosure () -> String,file: StaticString = #file, function: StaticString = #function, line: UInt = #line, tag: Any? = nil) {
        DDLogVerbose(message(),file:file,function:function,line:line,tag:tag)
    }
    
    static func errorLog(_ message: @autoclosure () -> String,file: StaticString = #file, function: StaticString = #function, line: UInt = #line, tag: Any? = nil) {
        DDLogError(message(),file:file,function:function,line:line,tag:tag)
    }
    
    
    let fileLogger: DDFileLogger = DDFileLogger() // File Logger
    
    static func setLogLevel(level : DDLogLevel) {
        dynamicLogLevel = level
    }
    
    @discardableResult
    init() {
        
        #if DEBUG || Staging
        dynamicLogLevel = DDLogLevel.all
        #else
        defaultDebugLevel = DDLogLevel.warning
        #endif
        
        DDTTYLogger.sharedInstance?.colorsEnabled = true
        
        DDLog.add(DDTTYLogger.sharedInstance!)
        
        fileLogger.rollingFrequency = TimeInterval(60*60*24)  // 24 hours
        fileLogger.logFileManager.maximumNumberOfLogFiles = 3
        DDLog.add(fileLogger)
        
        
    }
    
}
