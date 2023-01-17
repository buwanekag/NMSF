//
//  TwoImageSwoopyView.swift
//  NMSF
//
//  Created by Buwaneka Galpoththawela on 4/27/21.
//

import Foundation
import UIKit
class TwoImageSwoopyView: SwoopyView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
   override func getSwoopyPathMask() -> (UIBezierPath,UIBezierPath) {
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
    let bottomRightCircleCenter = CGPoint(x: rightX - curveRadius, y: bottomY)
    path.addArc(withCenter: bottomRightCircleCenter, radius: curveRadius, startAngle: 0, endAngle: 0, clockwise: false)
    
    border.addArc(withCenter: bottomRightCircleCenter, radius: curveRadius, startAngle: 0, endAngle: 0, clockwise: false)
    //Line goes left
    path.addLine(to: CGPoint(x: curveRadius, y: bottomY ) )
    let bottomLeftCircleCenter = CGPoint(x: 0, y:bottomY) // bottomY - (curveRadius * 2)
    path.addArc(withCenter: bottomLeftCircleCenter, radius: 0, startAngle:0, endAngle: 0, clockwise: true)
    path.close()
    return (path,border)
    }
    
}
