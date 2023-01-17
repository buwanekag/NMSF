//
//  TagListTableViewCell.swift
//  NMSF
//
//  Created by Buwaneka Galpoththawela on 5/4/21.
//

import UIKit
import TagListView
class TagListTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet var tagView: TagListView!
    @IBOutlet var tagListLeadingConstraint: NSLayoutConstraint!
    @IBOutlet var tagListTrailingConstraint: NSLayoutConstraint!
    @IBOutlet var tagListWidthConstraint: NSLayoutConstraint!
    
    func configure(viewModel: PointsOfInterestViewModel, cellWidth: CGFloat) {
        titleLabel.font =  UIFont.preferredFont(forTextStyle: .subheadline, weight: .bold)
        tagView.textFont = UIFont.preferredFont(forTextStyle: .subheadline, weight: .bold)
        tagView.removeAllTags()
        tagView.addTags(viewModel.areaAtaGlanceTags)
        
        /*
         Rediculous hack to fix the issue that the TagListView
         doesn't calculate its intrinsic content width correctly.
         If we don't do this sometimes the tag view is either too
         big or too small.
         
         This is because the UITableViewCell doesn't know its
         "real" width before it actually gets laid out. To
         fix this, we pass in the correct width of the cell
         so we can calcuate the "real" width and force it via
         setting its width constraint.
         */
        let realTagWidth = cellWidth - tagListLeadingConstraint.constant - tagListTrailingConstraint.constant
        NSLayoutConstraint.deactivate([tagListTrailingConstraint!])
        tagListWidthConstraint.constant = realTagWidth
        
        //Need this or the above hack won't work
        self.contentView.setNeedsLayout()
        self.contentView.layoutIfNeeded()
        self.layoutIfNeeded()
        
    }
}
