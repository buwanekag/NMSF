//
//  FoutImageCollectionViewCell.swift
//  NMSF
//
//  Created by Buwaneka Galpoththawela on 4/26/21.
//

import UIKit

class FourImageCollectionViewCell: UICollectionViewCell {
    var story: Story?
    
    func configure(story: Story) {
        self.story = story
        configureUI(story: story)
        
    }
    
    private let swoopyView: TwoImageSwoopyView = {
        let swoopyView = TwoImageSwoopyView()
        return swoopyView
    }()
    
    let nextButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.accessibilityLabel = Constants.Common.a11y.next
        return button
    }()
    
    let prevButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.accessibilityLabel = Constants.Common.a11y.previous
        return button
    }()
    
    func configureUI(story: Story) {
        
        let next = nextButton
        let prev = prevButton
        let viewSize = bounds.size
        var imageViews: [UIImageView] = []
        
        next.frame = CGRect(x: bounds.width / 2, y: 0.0, width: viewSize.width / 2, height: viewSize.height)
        prev.frame = CGRect(x: 0.0, y: 0.0, width: viewSize.width / 2, height: viewSize.height)
        
        let firstImageView = UIImageView(image: UIImage(named: story.imageName[0]))
        let secondImageView = BottomSwoopyView(image: UIImage(named: story.imageName[1]))
        let thirdImageView = TopSwoopyView(image: UIImage(named: story.imageName[2]))
        let fourthImageView = UIImageView(image: UIImage(named: story.imageName[3]))
        

        thirdImageView.isCurvedRight = false
        firstImageView.roundCorners(.bottomLeft, radius: 30)
        fourthImageView.roundCorners(.topRight, radius: 30)
        imageViews = [firstImageView,secondImageView,thirdImageView,fourthImageView]
        
        subviews.forEach { $0.removeFromSuperview() }
        imageViews.forEach(addSubview(_:))
        imageViews
            .enumerated()
            .forEach { $0.element.frame = frameForImageView(at: $0.offset) }
        let splitView = UIView(frame: CGRect(x: bounds.size.width / 2, y: 0, width: 1, height: bounds.size.height))
        splitView.backgroundColor = Constants.Color.floridaKeysGreen
        swoopyView.frame = frameForTwoImageView()
        addSubview(swoopyView)
        addSubview(splitView)
        addSubview(next)
        addSubview(prev)
        
    }
    
    private func
    frameForImageView(at index: Int) -> CGRect {
        var yVal =  CGFloat(0.0)
        var height = CGFloat(0.0)
        let viewSize = bounds.size
        let xVal = index % 2 == 0 ? 0.0 : viewSize.width / 2.0
        
        
        let width = viewSize.width / 2.0
        
        
        if index == 1 {
            yVal = (viewSize.height / 2.0) * floor(CGFloat(index) / 2.0) - SwoopyView().curveRadius
            height = viewSize.height / 2.0 + (SwoopyView().curveRadius * 2)
        } else if index == 2 {
            yVal = (viewSize.height / 2.0) * floor(CGFloat(index) / 2.0) - SwoopyView().curveRadius
            height = viewSize.height / 2.0 + (SwoopyView().curveRadius * 2)
        } else {
            yVal = (viewSize.height / 2.0) * floor(CGFloat(index) / 2.0)
            height = viewSize.height / 2.0
        }
        return CGRect(x: xVal, y: yVal, width: width, height: height)
    }
    
    private func frameForTwoImageView() -> CGRect {
        let viewSize = bounds.size
        let xVal = CGFloat(0.0)
        var yVal = CGFloat(0.0)
        var height = CGFloat(0.0)
        yVal = (viewSize.height / CGFloat(2)) - SwoopyView().curveRadius
        height = viewSize.height / CGFloat(2)
        
        let width = viewSize.width
        return CGRect(x: xVal, y: yVal, width: width, height: height)
        
        
        
    }
}
