//
//  PlanEmptyStateTableViewCell.swift
//  NMSF
//
//  Created by Matt Stanford on 4/30/21.
//

import UIKit
protocol PlanEmptyCellDelegate: AnyObject {
    func didSelectLocateSanctuary()
}
class PlanEmptyStateTableViewCell: UITableViewCell {
    
    @IBOutlet var emptyStateLabel: UILabel!
    @IBOutlet var emptyStateExploreContainerView: GradientView!
    @IBOutlet var emptyStateExploreButtonLabel: UILabel!
    @IBOutlet var emptyStateHelpContainerView: UIView!
    @IBOutlet var emptyStateHelpButtonLabel: UILabel!

    weak var delegate: PlanEmptyCellDelegate?
    func configure() {
        self.emptyStateLabel.font = UIFont.preferredFont(forTextStyle: .body, weight: .regular)
        self.emptyStateExploreButtonLabel.font = UIFont.preferredFont(forTextStyle: .body, weight: .bold)
        self.emptyStateHelpButtonLabel.font = UIFont.preferredFont(forTextStyle: .body, weight: .bold)
        
        let exploreGradientEndColor = UIColor(red: 0.137, green: 0.18, blue: 0.514, alpha: 1).cgColor
        emptyStateExploreContainerView.colors = [ Constants.Color.primaryBlue.cgColor, exploreGradientEndColor]
        
        emptyStateExploreContainerView.direction = .horizontal
        
        let exploreGR = UITapGestureRecognizer(target: self, action: #selector(tappedExploreSanctuary))
        self.emptyStateExploreContainerView.addGestureRecognizer(exploreGR)
        
        let helpGR = UITapGestureRecognizer(target: self, action: #selector(tappedHelp))
        self.emptyStateHelpContainerView.addGestureRecognizer(helpGR)
    }
    
    @objc private func tappedExploreSanctuary() {
        
        delegate?.didSelectLocateSanctuary()
        print("tapped explore the sanctuary!")
    }
    
    @objc private func tappedHelp() {
        print("tapped help!")
    }
    
}
