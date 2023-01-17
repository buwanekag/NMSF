//
//  CurveDrawable.swift
//  NMSF
//
//  Created by Matt Stanford on 5/14/21.
//

import UIKit

protocol CurveDrawable {}

extension CurveDrawable where Self: UIView {
    var angleDown: CGFloat {
        CGFloat(Double.pi / 2)
    }
    
    var angleLeft: CGFloat {
        CGFloat(Double.pi)
    }
    
    var angleUp: CGFloat {
        CGFloat((3 * Double.pi) / 2)
    }
    
    var angleRight: CGFloat {
        CGFloat(0)
    }
    
    var rightX: CGFloat {
        return self.frame.width
    }
    
    var bottomY: CGFloat {
        return self.frame.height
    }
}
