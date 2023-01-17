//
//  ZonePolygonPointPayload.swift
//  NMSF
//
//  Created by Matt Stanford on 5/24/21.
//

import Foundation

struct ZonePolygonPointPayload {
    let latitude: Double
    let longitude: Double
    
    init?(coordinateArray: [Double]) {
        guard coordinateArray.count == 2 else {
            return nil
        }
        self.latitude = coordinateArray[0]
        self.longitude = coordinateArray[1]
    }
}
