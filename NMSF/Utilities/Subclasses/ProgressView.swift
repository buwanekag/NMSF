//
//  ProgressView.swift
//  Thrive
//
//  Created by Robert Koch on 4/5/19.
//  Copyright © 2019 bmore. All rights reserved.
//

import UIKit

@IBDesignable
final class ProgressView: UIView {
    public let containerViewY: CGFloat = 20
    @IBInspectable var numberOfSegments: Int = 1 {
        didSet {
            segmentStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

            for _ in 0 ..< numberOfSegments {
                let segmentView = UIView()
                segmentStackView.addArrangedSubview(segmentView)
            }

            updateSegmentColors()
        }
    }

    @IBInspectable var incompleteSegmentColor: UIColor = .clear {
        didSet {
            updateSegmentColors()
        }
    }

    @IBInspectable var completeSegmentColor: UIColor = .white {
        didSet {
            updateSegmentColors()
        }
    }

    @IBInspectable var activeSegmentColor: UIColor = .white {
        didSet {
            updateSegmentColors()
        }
    }

    private(set) var currentSegment: Int? {
        didSet {
            updateSegmentColors()
        }
    }

    private lazy var containerView: DesignableView = {
        let containerView: DesignableView = DesignableView(frame: CGRect(x: bounds.minX, y: containerViewY, width: bounds.width, height: bounds.height))
        
        containerView.autoresizingMask = [.flexibleWidth]
        containerView.backgroundColor = .clear
        containerView.cornerRadius = 5
        containerView.clipsToBounds = true
        containerView.layer.bounds.size.height = 7
        addSubview(containerView)

        return containerView
    }()

    private lazy var segmentStackView: UIStackView = {
        let frame = CGRect(x: containerView.bounds.minX, y: containerView.bounds.minY, width: containerView.bounds.width, height: containerView.bounds.height)
        let segmentStackView = UIStackView(frame: frame)

        segmentStackView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        segmentStackView.axis = .horizontal
        segmentStackView.distribution = .fillEqually
        segmentStackView.spacing = 3.0
        containerView.addSubview(segmentStackView)

        return segmentStackView
    }()

    // MARK: - View

    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.cornerRadius = 5
    }

    // MARK: - Updating

    func setCurrentSegment(_ idx: Int?) {
        currentSegment = idx
    }

    private func updateSegmentColors() {
        #if !TARGET_INTERFACE_BUILDER
            let animator = UIViewPropertyAnimator(duration: 0.3, curve: .easeInOut, animations: { [weak self] in
                guard let self = self else {
                    return
                }

                self.setColors()
            })

            animator.startAnimation()
        #else
            setColors()
        #endif
    }

    private func setColors() {
        segmentStackView.arrangedSubviews.enumerated().forEach { idx, view in
            guard let currentSegment = self.currentSegment else {
                view.backgroundColor = .clear
                view.layer.borderColor = UIColor.white.cgColor
                view.layer.borderWidth = 1
                view.roundCorners(.allCorners, radius: 5)
                return
            }

            if idx < currentSegment {
                view.backgroundColor = .white
                view.layer.borderColor = UIColor.white.cgColor
                view.layer.borderWidth = 2
                view.roundCorners(.allCorners, radius: 5)
            } else if idx == currentSegment {
                view.backgroundColor = .clear
                view.layer.borderColor = UIColor.white.cgColor
                view.layer.borderWidth = 2
                view.roundCorners(.allCorners, radius: 5)
            } else {
                view.backgroundColor =  .clear
                view.layer.borderColor = UIColor.white.cgColor
                view.layer.borderWidth = 2
                view.roundCorners(.allCorners, radius: 5)
            }
        }
    }

    // MARK: - Interface Builder

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()

        segmentStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        for _ in 0 ..< numberOfSegments {
            let segmentView = UIView()

            segmentView.backgroundColor = .white
            segmentView.layer.borderColor = UIColor.white.cgColor
            segmentView.layer.borderWidth = 10
            segmentStackView.addArrangedSubview(segmentView)
        }

        currentSegment = max(numberOfSegments - 2, 0)
    }
}
