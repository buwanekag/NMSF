//
//  SortTableViewCell.swift
//  NMSF
//
//  Created by Buwaneka Galpoththawela on 6/3/21.
//

import UIKit
protocol SortCellDelegate: AnyObject {
    func tappedSort()
    func tappedClear()
}
class SortTableViewCell: UITableViewCell {

    @IBOutlet var sortContainerView: UIView!
    @IBOutlet var sortShadowView: UIView!
    @IBOutlet var sortLabel: UILabel!
    @IBOutlet var clearButton: UIButton!
    @IBOutlet var arrowImageView: UIImageView!
    
    weak var delegate: SortCellDelegate?
    
    func configure(planViewModel: PlanFilterViewModel, delegate: SortCellDelegate) {
        self.delegate = delegate
        
        sortLabel.attributedText = planViewModel.sortString
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(tappedSort))
        sortContainerView.addGestureRecognizer(tapGR)
        sortShadowView.addShadow()
        sortContainerView.isAccessibilityElement = true
        sortContainerView.accessibilityLabel = planViewModel.a11yText
        arrowImageView.image = planViewModel.showDownArrow ? Constants.Image.arrowDown : Constants.Image.arrowUp
       // clearButton.accessibilityLabel = Constants.Locate.Filter.clearA11yText
    }
    
    @objc func tappedSort() {
        arrowImageView.image = Constants.Image.arrowUp
        delegate?.tappedSort()
    }
    
    @IBAction func tappedClear() {
        delegate?.tappedClear()
    }
}
