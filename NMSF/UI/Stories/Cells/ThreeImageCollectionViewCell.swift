//
//  ThreeImageCollectionViewCell.swift
//  NMSF
//
//  Created by Buwaneka Galpoththawela on 4/27/21.
//

import UIKit

class ThreeImageCollectionViewCell: UICollectionViewCell {
  
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
        var imageViews: [UIImageView] = []
        
        next.frame = CGRect(x: bounds.width / 2, y: 0.0, width: viewSize.width / 2, height: viewSize.height)
        prev.frame = CGRect(x: 0.0, y: 0.0, width: viewSize.width / 2, height: viewSize.height)
        let firstImageView = BottomSwoopyView(image: UIImage(named: story.imageName[0]))
        let thirdImageView = TopSwoopyView(image: UIImage(named: story.imageName[1]))
        let secondImageView = SwoopyView(image: UIImage(named: story.imageName[2]))

        
        imageViews = [firstImageView,thirdImageView,secondImageView]
        
        subviews.forEach { $0.removeFromSuperview() }
        imageViews.forEach(addSubview(_:))
        imageViews
            .enumerated()
            .forEach { $0.element.frame = frameForImageView(at: $0.offset) }
        addSubview(next)
        addSubview(prev)
    }
    
    private func
    frameForImageView(at index: Int) -> CGRect {
        let viewSize = bounds.size
        let xVal = CGFloat(0.0)
        var yVal =  CGFloat(0.0)
        var height = CGFloat(0.0)
        let width = viewSize.width
        
        // Swapped indexes to change Y value of the swoopy view.
        if index == 1 {
            
            yVal = (viewSize.height / CGFloat(imageCount)) * CGFloat(2) - (SwoopyView().curveRadius * 2 )
            height = viewSize.height / CGFloat(imageCount) + (SwoopyView().curveRadius * 3 )
            
        } else if index == 2 {
            yVal = (viewSize.height / CGFloat(imageCount)) * CGFloat(1) - SwoopyView().curveRadius
            height = viewSize.height / CGFloat(imageCount) + SwoopyView().curveRadius
            
        } else {
            
            yVal = (viewSize.height / CGFloat(imageCount)) * CGFloat(index) - SwoopyView().curveRadius
            height = viewSize.height / CGFloat(imageCount) + (SwoopyView().curveRadius * 2 )
            
        }
        return CGRect(x: xVal, y: yVal, width: width, height: height)
    }
    
}
