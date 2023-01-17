//
//  GradientView.swift
//  NMSF
//
//  Created by Matt Stanford on 4/30/21.
//

import UIKit

class GradientView: UIView {

    enum Direction {
        case vertical
        case horizontal
        case angled
    }

    var direction: Direction = .vertical {
        didSet {
            guard let gradientLayer = self.layer as? CAGradientLayer else { return }
            switch direction {
            case .vertical:
                gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
                gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
            case .horizontal:
                gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
                gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
            case .angled:
                gradientLayer.startPoint = CGPoint(x: 0, y: 0)
                gradientLayer.endPoint = CGPoint(x: 1, y: 1)
            }
        }
    }

    var colors: [CGColor]? {
        didSet {
            guard let gradientLayer = self.layer as? CAGradientLayer else { return }
            gradientLayer.colors = colors
        }
    }

    var locations: [NSNumber]? {
        didSet {
            guard let gradientLayer = self.layer as? CAGradientLayer else { return }
            gradientLayer.locations = locations
        }
    }

    override public class var layerClass: Swift.AnyClass {
        return CAGradientLayer.self
    }

}
