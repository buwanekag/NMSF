//
//  StoryListCollectionContainerCell.swift
//  NMSF
//
//  Created by Clay Suttner on 10/3/21.
//

import UIKit

class StoryListCollectionContainerCell: UITableViewCell {
    @IBOutlet private weak var collectionContainer: UIView!
    @IBOutlet private weak var cornerMaskView: StoryCollectionCornerMaskView!
    
    func embedView(_ view: UIView) {
        collectionContainer.addSubview(view)
        view.frame = collectionContainer.bounds
    }
}

class StoryCollectionCornerMaskView: UIView, CurveDrawable {
    private let curveRadius: CGFloat = 30
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let path = UIBezierPath()

        path.move(to: CGPoint(x: rightX - curveRadius, y: 0))
        
        let firstCirclePoint = CGPoint(x: rightX - curveRadius, y: curveRadius)
        path.addArc(withCenter: firstCirclePoint, radius: curveRadius, startAngle: angleUp, endAngle: angleRight, clockwise: true)
        
        path.addLine(to: CGPoint(x: rightX, y: bottomY - curveRadius))
        
        let secondCirclePoint = CGPoint(x: rightX - curveRadius, y: bottomY - curveRadius)
        path.addArc(withCenter: secondCirclePoint, radius: curveRadius, startAngle: angleRight, endAngle: angleDown, clockwise: true)
        
        path.addLine(to: CGPoint(x: rightX, y: bottomY))
        path.addLine(to: CGPoint(x: rightX, y: 0))
        path.close()
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        layer.mask = maskLayer
    }
}
