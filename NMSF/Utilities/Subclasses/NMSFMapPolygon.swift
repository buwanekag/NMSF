//
//  NMSFMapPolygon.swift
//  NMSF
//
//  Created by Matt Stanford on 5/26/21.
//

import Foundation
import MapKit

enum MapBoundaryDrawStyle {
    case solid
    case dashed
}

class NMSFMapPolygon: MKPolygon {
    
    var drawStyle: MapBoundaryDrawStyle?
    
    var lineColor: UIColor {
        switch drawStyle {
        case .dashed:
            return Constants.Color.mapDashYellow
        default:
            return UIColor.white
        }
    }
    
    var lineWidth: CGFloat {
        return 1.5
    }
    
    var lineDashPattern: [NSNumber]? {
        guard let drawStyle = drawStyle,
              drawStyle == .dashed else {
            return nil
        }
        
        /*
         According to apple docs: these numbers correspond to:
            index 0: length of dash
            index 1: space in between dashes
         */
        return [6, 10]
    }
    
}
