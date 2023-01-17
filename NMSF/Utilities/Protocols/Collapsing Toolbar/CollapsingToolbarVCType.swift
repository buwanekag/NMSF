//
//  CollapsingToolbarVCType.swift
//  NMSF
//
//  Created by Matt Stanford on 4/23/21.
//

import UIKit

/*
 Instructions for use:
 
 1. Have a VC with a tableview/scrollview, and make sure it is pinned to the top of the main view
 2. Place a UIView on top of it (this will set insets so all of the content can be seen). This view should be a custom class for your collapsing view, and it must implement the protocol "CollapsingHeaderViewType" (example: DiscoverHeaderView)
 3. Do NOT give the header view a height constraint. To fix IB complaining about no height/y position,
    give it a placeholder value in IB. CollapsingHeaderViewType views calculate their own height and
    later adds a height constraint programmatically.
 4. Make your VC implement this protocol - add a "var scrollView" computed property if you have a tableview, add an IBoutlet to your headerView (in code should be a UIView), and add a declaration for the "toolbarHeightConstraint"
 5. Add "initializeHeaderHeight" to "viewDidLayoutSubviews", "potentiallyAdjustToolbarHeight" to "scrollViewDidScroll"

 */

typealias CollapsableViewImplementation = CollapsingHeaderViewType & UIView

protocol CollapsingToolbarVCType: UIViewController, UIScrollViewDelegate {
    var toolbarHeightConstraint: NSLayoutConstraint? { get set }
    var scrollView: UIScrollView! { get }
    var headerView: UIView! { get }
}

extension CollapsingToolbarVCType {

    /*
     Place in viewDidLayoutSubviews
     */
    func initializeHeaderHeight() {
        guard let collapsableHeader = self.headerView as? CollapsableViewImplementation else {
            fatalError("Collapsable Header must implement CollapsingHeaderViewType!")
        }
        
        if collapsableHeader.needsHeightInitialization {
            collapsableHeader.initializeMaxHeight(containerView: self)
            self.toolbarHeightConstraint = NSLayoutConstraint(item: collapsableHeader, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: collapsableHeader.maxHeight)
            collapsableHeader.addConstraint(toolbarHeightConstraint!)

            //This is needed since sometimes table isn't auto-scrolled to max offset
            let initialOffset = -1 * collapsableHeader.maxHeight
            self.scrollView.setContentOffset(CGPoint(x: 0, y: initialOffset), animated: false)
        }
    }

    /*
     Place in scrollViewDidScroll(_ scrollView:)
     */
    func potentiallyAdjustToolbarHeight(_ scrollView: UIScrollView, offset: CGFloat = 0) {
        guard let collapsableHeader = self.headerView as? CollapsableViewImplementation else {
            fatalError("Collapsable Header must implement CollapsingHeaderViewType!")
        }
        
        let y: CGFloat = scrollView.contentOffset.y + offset
        let newHeaderViewHeight: CGFloat = y * -1

        if newHeaderViewHeight > collapsableHeader.maxHeight {
            toolbarHeightConstraint?.constant = collapsableHeader.maxHeight
        } else if newHeaderViewHeight < collapsableHeader.minHeight {
            toolbarHeightConstraint?.constant = collapsableHeader.minHeight
        } else {
            toolbarHeightConstraint?.constant = newHeaderViewHeight
        }
        collapsableHeader.changedHeight(newHeight: newHeaderViewHeight)
    }
}
