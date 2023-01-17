//
//  SwoopyView.swift
//  NMSF
//
//  Created by Buwaneka Galpoththawela on 4/21/21.
//

import Foundation
import UIKit

class SwoopyView: UIImageView, CurveDrawable {
    
    public var curveRadius: CGFloat {return 30} 
    
    public let path = UIBezierPath()
    public let border = UIBezierPath()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = getSwoopyPathMask().0.cgPath
        
        self.layer.mask = maskLayer
        
        let borderLayer = CAShapeLayer()
        borderLayer.path = getSwoopyPathMask().1.cgPath
        borderLayer.lineWidth = 2
        borderLayer.strokeColor = Constants.Color.floridaKeysGreen.cgColor
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.frame = self.bounds
        self.layer.addSublayer(borderLayer)
        
    }
    
    func getSwoopyPathMask() -> (UIBezierPath,UIBezierPath) {
        
        path.lineWidth = 30
        
        //Start at top-left
        path.move(to: CGPoint(x: 0, y: 0))
        border.move(to: CGPoint(x: 0, y: 0))
        
        //Top-left curve
        let topLeftCirclePoint = CGPoint(x: curveRadius, y: 0)
        path.addArc(withCenter: topLeftCirclePoint, radius: curveRadius, startAngle: angleLeft, endAngle: angleDown, clockwise: false)
        
        border.addArc(withCenter: topLeftCirclePoint, radius: curveRadius, startAngle: angleLeft, endAngle: angleDown, clockwise: false)
        
        
        //Draw straight line to right side
        let topRightLineEnd = rightX - curveRadius
        path.addLine(to: CGPoint(x: topRightLineEnd, y: curveRadius))
        
        border.addLine(to: CGPoint(x: topRightLineEnd, y: curveRadius))
        
        //Top-right curves down
        let topRightCircleCenter = CGPoint(x: topRightLineEnd, y: curveRadius * 2)
        path.addArc(withCenter: topRightCircleCenter, radius: curveRadius, startAngle: angleUp, endAngle: angleRight, clockwise: true)
        
        border.addArc(withCenter: topRightCircleCenter, radius: curveRadius, startAngle: angleUp, endAngle: angleRight, clockwise: true)
        
        
        //Line goes from end of top right curve to bottom
        path.addLine(to: CGPoint(x: rightX, y: bottomY))
        
        border.addLine(to: CGPoint(x: rightX, y: bottomY))
        
        //Bottom right curve
        let bottomRightCircleCenter = CGPoint(x: rightX - curveRadius, y: bottomY)
        path.addArc(withCenter: bottomRightCircleCenter, radius: curveRadius, startAngle: angleRight, endAngle: angleUp, clockwise: false)
        
        border.addArc(withCenter: bottomRightCircleCenter, radius: curveRadius, startAngle: angleRight, endAngle: angleUp, clockwise: false)
        
        //Line goes left
        path.addLine(to: CGPoint(x: curveRadius, y: bottomY - curveRadius))
        
        border.addLine(to: CGPoint(x: curveRadius, y: bottomY - curveRadius))
        
        //Bottom left curve
        let bottomLeftCircleCenter = CGPoint(x: curveRadius, y: bottomY - (curveRadius * 2))
        path.addArc(withCenter: bottomLeftCircleCenter, radius: curveRadius, startAngle: angleDown, endAngle: angleLeft, clockwise: true)
        
        border.addArc(withCenter: bottomLeftCircleCenter, radius: curveRadius, startAngle: angleDown, endAngle: angleLeft, clockwise: true)
        //go to the beginning up
        path.addLine(to: CGPoint(x: 0, y: 0))
        
        border.addLine(to: CGPoint(x: 0, y: 0))
        path.close()
        border.close()
        
        
        return (path,border)
    }
}
