//
//  BottomSwoopyView.swift
//  NMSF
//
//  Created by Buwaneka Galpoththawela on 5/21/21.
//

import Foundation
import UIKit

class BottomSwoopyView: UIImageView, CurveDrawable {
    
    public var curveRadius: CGFloat {return 30}
    
    public let path = UIBezierPath()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = getSwoopyPathMask().cgPath
        
        self.layer.mask = maskLayer
    }
    
    func getSwoopyPathMask() -> (UIBezierPath) {
        
        path.lineWidth = 30
        
        //Start at top-left
        path.move(to: CGPoint(x: 0, y: 0))
        
        //Top-left curve
        let topLeftCirclePoint = CGPoint(x: 0, y: curveRadius)
        path.addArc(withCenter: topLeftCirclePoint, radius: curveRadius, startAngle: angleLeft, endAngle: angleUp, clockwise: true)
        
        
        //Draw straight line to right side
        let topRightLineEnd = rightX + curveRadius
        path.addLine(to: CGPoint(x: topRightLineEnd, y: CGFloat(0)))
        
        
        //Top-right curves down
        let topRightCircleCenter = CGPoint(x: topRightLineEnd, y: curveRadius * 2)
        path.addArc(withCenter: topRightCircleCenter, radius: curveRadius, startAngle: angleUp, endAngle: angleRight, clockwise: true)
        
        
        
        //Line goes from end of top right curve to bottom
        path.addLine(to: CGPoint(x: rightX, y: bottomY))
        
        
        //Bottom right curve
        let bottomRightCircleCenter = CGPoint(x: rightX - curveRadius, y: bottomY)
        path.addArc(withCenter: bottomRightCircleCenter, radius: curveRadius, startAngle: angleRight, endAngle: angleUp, clockwise: false)
        
        
        //Line goes left
        path.addLine(to: CGPoint(x: curveRadius, y: bottomY - curveRadius))
        
        
        //Bottom left curve
        let bottomLeftCircleCenter = CGPoint(x: curveRadius, y: bottomY - (curveRadius * 2))
        path.addArc(withCenter: bottomLeftCircleCenter, radius: curveRadius, startAngle: angleDown, endAngle: angleLeft, clockwise: true)
        
        
        //go to the beginning up
        path.addLine(to: CGPoint(x: 0, y: 0))
        
        
        path.close()
        
        
        
        return (path)
    }
}

