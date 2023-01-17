//
//  PlanFilterTableViewCell.swift
//  NMSF
//
//  Created by Matt Stanford on 4/29/21.
//

import UIKit

protocol PlanFilterDelegate: AnyObject {
    func tappedSort()
    func tappedEdit()
}

class PlanFilterTableViewCell: UITableViewCell {

    @IBOutlet var sortContainerView: UIView!
    @IBOutlet var sortShadowView: UIView!
    @IBOutlet var sortLabel: UILabel!
    @IBOutlet var editButton: UIButton!
    @IBOutlet var arrowImageView: UIImageView!
    
    weak var delegate: PlanFilterDelegate?
    
    func configure(planViewModel: PlanFilterViewModel, delegate: PlanFilterDelegate) {
        self.delegate = delegate
        
        sortLabel.attributedText = planViewModel.sortString
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(tappedSort))
        sortContainerView.addGestureRecognizer(tapGR)
        sortShadowView.addShadow()
        sortContainerView.isAccessibilityElement = true
        sortContainerView.accessibilityLabel = planViewModel.a11yText
        arrowImageView.image = planViewModel.showDownArrow ? Constants.Image.arrowDown : Constants.Image.arrowUp
        editButton.setImage(planViewModel.editPencilImage, for: .normal)
        editButton.accessibilityLabel = Constants.Plan.planEditPencilA11yText
       
    }
    func configureForBottomSheet(planViewModel: PlanFilterViewModel, delegate: PlanFilterDelegate) {
        self.delegate = delegate
        
        sortLabel.attributedText = planViewModel.sortString
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(tappedSort))
     
        sortContainerView.addGestureRecognizer(tapGR)
        sortShadowView.addShadow()
        sortContainerView.isAccessibilityElement = true
        sortContainerView.accessibilityLabel = planViewModel.a11yText
        arrowImageView.image = planViewModel.showDownArrow ? Constants.Image.arrowDown : Constants.Image.arrowUp
        editButton.isHidden = true
    }
    @objc func tappedSort() {
        
        delegate?.tappedSort()
    }
    
    @IBAction func tappedEdit() {
        delegate?.tappedEdit()
    }
    
}
