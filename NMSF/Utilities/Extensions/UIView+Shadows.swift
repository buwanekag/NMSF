//
//  UIView+Shadows.swift
//  NMSF
//
//  Created by Matt Stanford on 4/23/21.
//

import UIKit

extension UIView {

    func addShadow(color: UIColor = Constants.Color.primaryBlue, opacity: Float = 0.15, offset: CGSize = CGSize(width: 2, height: 2), radius: Float = 4) {
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offset
        layer.shadowRadius = CGFloat(radius)
        layer.masksToBounds = false
    }

    func removeShadow() {
        layer.shadowColor = nil
        layer.shadowOpacity = 0
        layer.shadowOffset = .zero
        layer.shadowRadius = 0
    }

}
