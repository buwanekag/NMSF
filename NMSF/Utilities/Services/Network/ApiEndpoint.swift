//
//  ApiEndpoint.swift
//  NMSF
//
//  Created by Matt Stanford on 5/21/21.
//

import Foundation

enum ApiEndpoint {
    case sites
    case zones
}

extension ApiEndpoint {
    
    private var baseUrl: String {
        Constants.Environment.baseUrl
    }
    
    var path: String {
        switch self {
        case .sites:
            return "\(baseUrl)/type/Site"
        case .zones:
            return "\(baseUrl)/type/Zone"
        }
    }
    
    var queryParams: [String: String]? {
        let entityLimit = 9999
        
        switch self {
        case .sites:
            let includeItems = "guidelines,supportsActivity,regulatedBy,accessibleBy,containedIn,zoneType,siteType,habitat"
            return ["include": includeItems, "limit": entityLimit.description]
        case .zones:
            let includeItems = "guidelines,supportsActivity,regulatedBy,accessibleBy,containedIn,zoneType"
            
            return ["include": includeItems, "limit": entityLimit.description]
        }
    }
}
