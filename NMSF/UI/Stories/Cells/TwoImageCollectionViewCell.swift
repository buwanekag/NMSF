//
//  TwouImageCollectionViewCell.swift
//  NMSF
//
//  Created by Buwaneka Galpoththawela on 4/27/21.
//

import UIKit

class TwoImageCollectionViewCell: UICollectionViewCell {
    var story: Story?
    var imageCount: Int  = 0
    
    func configure(story: Story) {
        self.story = story
        self.imageCount = story.imageName.count
        
        configureUI(story: story)
        
    }
    
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
        next.frame = CGRect(x: bounds.width / 2, y: 0.0, width: viewSize.width / 2, height: viewSize.height)
        prev.frame = CGRect(x: 0.0, y: 0.0, width: viewSize.width / 2, height: viewSize.height)
        var imageViews: [UIImageView] = []
        
        let firstImageView = BottomSwoopyView(image: UIImage(named: story.imageName[0]))
        let secondImageView = TwoImageSwoopyView(image: UIImage(named: story.imageName[1]))
        
        
        imageViews = [firstImageView,secondImageView]
        
        subviews.forEach { $0.removeFromSuperview() }
        imageViews.forEach(addSubview(_:))
        imageViews
            .enumerated()
            .forEach { $0.element.frame = frameForImageView(at: $0.offset) }
        let splitView = UIView(frame: CGRect(x: bounds.size.width / 2, y: 0, width: 1, height: bounds.size.height))
        splitView.backgroundColor = UIColor.green
        addSubview(next)
        addSubview(prev)
        
    }
    
    private func
    frameForImageView(at index: Int) -> CGRect {
        let viewSize = bounds.size
        let xVal = CGFloat(0.0)
        var yVal = CGFloat(0.0)
        var height = CGFloat(0.0)
        if index == 0 {
            yVal = (viewSize.height / CGFloat(imageCount)) * CGFloat(index) - SwoopyView().curveRadius
            height = viewSize.height / CGFloat(imageCount) + (SwoopyView().curveRadius * 2)
        } else {
            yVal = (viewSize.height / CGFloat(imageCount)) * CGFloat(index) - SwoopyView().curveRadius
            height = viewSize.height / CGFloat(imageCount) + SwoopyView().curveRadius
        }
        
        let width = viewSize.width
        return CGRect(x: xVal, y: yVal, width: width, height: height)
    }
    
    
}
