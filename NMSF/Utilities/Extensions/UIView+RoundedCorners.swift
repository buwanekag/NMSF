//
//  UIView+RoundedCorners.swift
//  NMSF
//
//  Created by Buwaneka Galpoththawela on 5/10/21.
//

import Foundation
import UIKit

extension UIView {

    /**
     Rounds the given set of corners to the specified radius
     
     - parameter corners: Corners to round
     - parameter radius:  Radius to round to
     */
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        layer.masksToBounds = true
        layer.maskedCorners = corners.cornerMask
        layer.cornerRadius = radius
    }

    /**
     Rounds the given set of corners to the specified radius with a border
     
     - parameter corners:     Corners to round
     - parameter radius:      Radius to round to
     - parameter borderColor: The border color
     - parameter borderWidth: The border width
     */
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat, borderColor: UIColor, borderWidth: CGFloat) {
        layer.masksToBounds = true
        layer.maskedCorners = corners.cornerMask
        layer.cornerRadius = radius
        layer.borderColor = borderColor.cgColor
        layer.borderWidth = borderWidth
    }

}

extension UIRectCorner {
    var cornerMask: CACornerMask {
        var cornerMask: CACornerMask = []

        if contains(.topLeft) {
            cornerMask.formUnion(.layerMinXMinYCorner)
        }

        if contains(.topRight) {
            cornerMask.formUnion(.layerMaxXMinYCorner)
        }

        if contains(.bottomLeft) {
            cornerMask.formUnion(.layerMinXMaxYCorner)
        }

        if contains(.bottomRight) {
            cornerMask.formUnion(.layerMaxXMaxYCorner)
        }

        return cornerMask
    }
}
