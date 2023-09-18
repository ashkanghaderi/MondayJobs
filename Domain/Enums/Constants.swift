//
//  Constants.swift
//  Domain
//
//  Created by Ashkan Ghaderi on 8/8/20.
//  Copyright © 2020 Elinium. All rights reserved.
//

public enum BaseURL: String {
    
    case dev = "https://dev.mondayjobs.ca"
    
    case soket = "https://mondayjobs.ca/signal_exhibition"
    
}

// MARK: - ServiceRouter Definition

public enum ServiceRouter {
    
    case AuthServiceRoute(AuthRoute)
    case ExhibitionServiceRoute(ExhibitionRoute)
    case CompanyServiceRoute(CompanyRoute)
    case VideoServiceRoute(VideoRoute)
}

extension ServiceRouter {
    public var url: String {
        switch self {
        case .AuthServiceRoute(let authRoute):
            return authRoute.path
            
        case .ExhibitionServiceRoute(let exhRoute):
            return exhRoute.path
            
        case .CompanyServiceRoute(let comRoute):
            return comRoute.path
            
        case .VideoServiceRoute(let videoRoute):
            return videoRoute.path
        
        }
 
    }
}


// MARK: - AuthRoute

public enum AuthRoute: String {
    
    case register = "/Attendees/register"
    case login = "/Attendees/login"
    case requestreset = "/Attendees/requestreset"
    case resetpass = "/Attendees/resetpass"
    case activate = "/Attendees/activate"
    case profile = "/Attendees/me"
    case avatar = "/Attendees/me/avatar"
    case resume = "/Attendees/me/resume"
    
    var path: String {
        return "/api/" + AppSetting.API_VERSION + rawValue
    }
}

// MARK: - CompanyRoute

public enum CompanyRoute: String {
    
    case company = "/Company"
    
    
    var path: String {
        return "/api/" + AppSetting.API_VERSION + rawValue
    }
}

// MARK: - ExhibitionRoute

public enum ExhibitionRoute: String {
    
    case current = "/Exhibition/current"
    case search = "/Exhibition/current/search"
    case watchList = "/Exhibition/attendee/watchlist"
    case watch = "/Exhibition/attendee/watch"
    
    var path: String {
        return "/api/" + AppSetting.API_VERSION + rawValue
    }
}

public enum VideoRoute: String {
    
    case VideoInit = "/Videos/init"
    case close = "/Videos/room/close"
    case join = "/Videos/agent/"
    case left = "/Videos/agent/participant_left"
    
    
    var path: String {
        return "/api/" + AppSetting.API_VERSION + rawValue
    }
}

public enum UploadRoute: String {
    
    case image = "/Files/images"
    case docs = "/Videos/room/close"
    case share = "/Files/share/%d1/%d2"
    
    
    var path: String {
        return "/api/" + AppSetting.API_VERSION + rawValue
    }
}

