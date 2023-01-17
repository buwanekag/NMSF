//
//  DesignableView.swift
//  Thrive
//
//  Created by Robert Koch on 10/4/18.
//  Copyright © 2018 bmore. All rights reserved.
//

import UIKit

@IBDesignable
@available(iOS 11.0, *)
class DesignableView: UIView {
    // MARK: - Corners

    private var cornerMask: CACornerMask = [] {
        didSet {
            layer.maskedCorners = cornerMask
        }
    }

    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            layer.cornerRadius = cornerRadius
            updateCorners()
        }
    }

    @IBInspectable var roundTopLeft: Bool = true {
        didSet {
            updateCorners()
        }
    }

    @IBInspectable var roundTopRight: Bool = true {
        didSet {
            updateCorners()
        }
    }

    @IBInspectable var roundBottomLeft: Bool = true {
        didSet {
            updateCorners()
        }
    }

    @IBInspectable var roundBottomRight: Bool = true {
        didSet {
            updateCorners()
        }
    }

    @IBInspectable var roundView: Bool = false {
        didSet {
            updateCorners()
        }
    }

    private func updateCorners() {
        if roundView {
            cornerMask = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
            layer.cornerRadius = min(bounds.width, bounds.height) / 2.0
        } else {
            if roundTopLeft, !cornerMask.contains(.layerMinXMinYCorner) {
                cornerMask.insert(.layerMinXMinYCorner)
            } else if !roundTopLeft, cornerMask.contains(.layerMinXMinYCorner) {
                cornerMask.remove(.layerMinXMinYCorner)
            }

            if roundTopRight, !cornerMask.contains(.layerMaxXMinYCorner) {
                cornerMask.insert(.layerMaxXMinYCorner)
            } else if !roundTopRight, cornerMask.contains(.layerMaxXMinYCorner) {
                cornerMask.remove(.layerMaxXMinYCorner)
            }

            if roundBottomLeft, !cornerMask.contains(.layerMinXMaxYCorner) {
                cornerMask.insert(.layerMinXMaxYCorner)
            } else if !roundBottomLeft, cornerMask.contains(.layerMinXMaxYCorner) {
                cornerMask.remove(.layerMinXMaxYCorner)
            }

            if roundBottomRight, !cornerMask.contains(.layerMaxXMaxYCorner) {
                cornerMask.insert(.layerMaxXMaxYCorner)
            } else if !roundBottomRight, cornerMask.contains(.layerMaxXMaxYCorner) {
                cornerMask.remove(.layerMaxXMaxYCorner)
            }

            layer.cornerRadius = cornerRadius
        }
    }

    // MARK: - Border

    @IBInspectable var borderColor: UIColor? = .clear {
        didSet {
            layer.borderColor = borderColor?.cgColor
        }
    }

    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }

    // MARK: - Shadow

    @IBInspectable var shadowColor: UIColor = .clear {
        didSet {
            layer.shadowColor = shadowColor.cgColor
        }
    }

    @IBInspectable var shadowOffset: CGSize = .zero {
        didSet {
            layer.shadowOffset = shadowOffset
        }
    }

    @IBInspectable var shadowOpacity: Float = 0.0 {
        didSet {
            layer.shadowOpacity = shadowOpacity
        }
    }

    @IBInspectable var shadowRadius: CGFloat = 0.0 {
        didSet {
            layer.shadowRadius = shadowRadius
        }
    }

    // MARK: - Gradient

    @IBInspectable var gradientStartColor: UIColor = .clear {
        didSet {
            if let layer = self.layer as? CAGradientLayer {
                layer.colors = [self.gradientStartColor.cgColor, self.gradientEndColor.cgColor]
            }
        }
    }

    @IBInspectable var gradientEndColor: UIColor = .clear {
        didSet {
            if let layer = self.layer as? CAGradientLayer {
                layer.colors = [self.gradientStartColor.cgColor, self.gradientEndColor.cgColor]
            }
        }
    }

    @IBInspectable var gradientStart: CGPoint = CGPoint(x: 0.0, y: 1.0) {
        didSet {
            if let layer = self.layer as? CAGradientLayer {
                layer.startPoint = gradientStart
            }
        }
    }

    @IBInspectable var gradientEnd: CGPoint = CGPoint(x: 1.0, y: 0.0) {
        didSet {
            if let layer = self.layer as? CAGradientLayer {
                layer.endPoint = self.gradientEnd
            }
        }
    }

    // MARK: - View

    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateCorners()
        layer.shouldRasterize = shadowColor != .clear && shadowOpacity != 0.0
    }
}



