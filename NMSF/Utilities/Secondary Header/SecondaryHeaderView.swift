//
//  SecondaryHeaderView.swift
//  NMSF
//
//  Created by Matt Stanford on 5/14/21.
//

import UIKit

class SecondaryHeaderView: UIView, CurveDrawable {
    
    private let curveRadius: CGFloat = 30
    private let blueBarHorizontalMargin: CGFloat = 42
    
    let backgroundImageView = UIImageView()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundImageView.image = Constants.Image.waveBackground
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.frame = self.frame
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = getBottomSwoopyMask().cgPath
        backgroundImageView.layer.mask = maskLayer
        
        addSubview(backgroundImageView)

        addSubview(getBlueBarView())
        
        self.backgroundColor = .clear
        self.clipsToBounds = true

    }
    
    private func getBottomSwoopyMask() -> UIBezierPath {
        let path = UIBezierPath()
        
        //Start at bottom-left
        path.move(to: CGPoint(x: 0, y: bottomY))
        
        //Curve up and to the right (shape of the top left of circle)
        
        let firstCirclePoint = CGPoint(x: curveRadius, y: bottomY)
        path.addArc(withCenter: firstCirclePoint, radius: curveRadius, startAngle: angleLeft, endAngle: angleUp, clockwise: true)
        
        //Draw straight across to right side
        let topLineY = bottomY - curveRadius
        let topLineEndX = rightX - (curveRadius * 2)
        path.addLine(to: CGPoint(x: topLineEndX, y: topLineY))

        //Curve up and to the right (shape of the bottom right of circle)
        let secondCircleX = topLineEndX + curveRadius
        let secondCircleY = topLineY - curveRadius
        let secondCirclePoint = CGPoint(x: secondCircleX, y: secondCircleY)
        path.addArc(withCenter: secondCirclePoint, radius: curveRadius, startAngle: angleDown, endAngle: angleRight, clockwise: false)

        //Draw stright to top
        path.addLine(to: CGPoint(x: rightX, y: 0))

        //Draw stright across to the left
        path.addLine(to: CGPoint(x: 0, y: 0))
        path.close()
        
        return path
    }
    
    private func getBlueBarView() -> UIView {
        
        let barX = blueBarHorizontalMargin
        let barY = bottomY - curveRadius
        let height: CGFloat = 6
        let width = (rightX - (blueBarHorizontalMargin * 2))
        let color = Constants.Color.floridaKeysGreen
        
        let blueBarView = UIView(frame: CGRect(x: barX, y: barY, width: width, height: height))
        blueBarView.backgroundColor = color
        blueBarView.layer.cornerRadius = 3
        blueBarView.clipsToBounds = true
        
        return blueBarView
    }
    
    var recommendedContentInset: UIEdgeInsets {
        return UIEdgeInsets(top: curveRadius, left: 0, bottom: 0, right: 0)
    }
}
