//
//  CollectionViewCell.swift
//  NMSF
//
//  Created by Buwaneka Galpoththawela on 4/22/21.
//

import UIKit

class OneImageCollectionViewCell: UICollectionViewCell {
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
    
    func configureUI(story: Story) {
        let button = nextButton
        let viewSize = bounds.size
        button.frame = CGRect(x: bounds.width / 2, y: 0.0, width: viewSize.width / 2, height: viewSize.height)
        var imageViews: [UIImageView] = []
        
        let firstImageView = UIImageView(image: UIImage(named: story.imageName[0]))
        firstImageView.tintColor = .clear
        imageViews = [firstImageView]
        
        subviews.forEach { $0.removeFromSuperview() }
        imageViews.forEach(addSubview(_:))
        imageViews
            .enumerated()
            .forEach { $0.element.frame = frameForImageView(at: $0.offset) }
        let splitView = UIView(frame: CGRect(x: bounds.size.width / 2, y: 0, width: 1, height: bounds.size.height))
        splitView.backgroundColor = UIColor.green
        addSubview(nextButton)
        
    }
    
    private func
    frameForImageView(at index: Int) -> CGRect {
        let viewSize = bounds.size
        
        let xVal = CGFloat(0.0)
        let yVal = (viewSize.height / CGFloat(imageCount)) * CGFloat(index)
        
        let width = viewSize.width
        let height = viewSize.height / CGFloat(imageCount)
        
        return CGRect(x: xVal, y: yVal, width: width, height: height)
    }
}
