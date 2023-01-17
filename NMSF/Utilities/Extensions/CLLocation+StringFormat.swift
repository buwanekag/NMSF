//
//  CLLocation+StringFormat.swift
//  NMSF
//
//  Created by Matt Stanford on 5/26/21.
//

import CoreLocation
import Foundation

extension CLLocation {
    
    func stringInDecimalDegrees(decimalPrecision: Int) -> String {
        //Decimal degrees format (e.g. "32.43° N, 122.63° W")
        let northSouth = self.coordinate.latitude > 0 ? "N" : "S"
        let eastWest = self.coordinate.longitude > 0 ? "E" : "W"
        let absLat = abs(self.coordinate.latitude)
        let absLon = abs(self.coordinate.longitude)
        
        let coordFormat = NSString(format: "%%.%if°", decimalPrecision)
        let latString = NSString(format: coordFormat, absLat)
        let lonString = NSString(format: coordFormat, absLon)
        
        return String(format: NSLocalizedString("%@ %@, %@ %@", comment: ""), latString, northSouth, lonString, eastWest)
    }
}
