//
//  JsonApiResponse.swift
//  NMSF
//
//  Created by Matt Stanford on 5/21/21.
//

import Foundation

struct JsonApiResponse<T: Decodable>: Decodable {
    let data: T
    let included: [JSON]?
    let meta: JSON?
    
    var includedMap: [String: JSON]? {
        guard let included = included else {
            return nil
        }
        
        var includedMap: [String: JSON] = [:]
        included.forEach { json in
            if let id = json.rawValue["id"] as? String {
                includedMap[id] = json
            }
        }
        
        return includedMap
    }
}
