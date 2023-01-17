//
//  DiscoverTableViewCell.swift
//  NMSF
//
//  Created by Matt Stanford on 4/23/21.
//

import UIKit

class DiscoverTableViewCell: UITableViewCell {
    @IBOutlet var containerView: UIView!
    @IBOutlet var containerShadowView: UIView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var newIndicatorStackView: UIStackView!
    @IBOutlet var newIndicatorLabel: UILabel!
   
    func configure(viewModel: DiscoverItemViewModel, searchString: String) {
        addHighlight(currentString: viewModel.storyTitle, highlightString: searchString)
        titleLabel.font = UIFont.preferredFont(forTextStyle: .title2, weight: .bold)
        
        newIndicatorLabel.font = UIFont.preferredFont(forTextStyle: .subheadline, weight: .bold)
        
        if viewModel.isNew {
            containerView.layer.borderWidth = 2
            containerView.layer.borderColor = Constants.Color.floridaKeysGreen.cgColor
            newIndicatorStackView.isHidden = false
            
        } else {
            containerView.layer.borderWidth = 0
            containerView.layer.borderColor = UIColor.white.cgColor
            newIndicatorStackView.isHidden = true
        }
        
        containerShadowView.addShadow(opacity: 0.15, offset: CGSize(width: 4, height: 4), radius: 8)
    }
    
    private func addHighlight(currentString: String, highlightString: String) {

        let attribText = NSMutableAttributedString(string: currentString)
        let range: NSRange = attribText.mutableString.range(of: highlightString, options: .caseInsensitive)
        
        var attributes: [NSAttributedString.Key: Any] = [:]
        
      
        attributes[.backgroundColor] = Constants.Color.floridaKeysGreen
        
        attribText.addAttributes(attributes, range: range)
        titleLabel.attributedText = attribText
    }
    
}
