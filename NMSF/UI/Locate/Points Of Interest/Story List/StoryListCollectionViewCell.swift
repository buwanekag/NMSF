//
//  StoryListCollectionViewCell.swift
//  NMSF
//
//  Created by Buwaneka Galpoththawela on 4/30/21.
//

import UIKit

class StoryListCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var designableView: DesignableView!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    func configureUI(){
        detailLabel.font = UIFont.preferredFont(forTextStyle: .subheadline, weight: .bold)
        
        designableView.borderColor = Constants.Color.floridaKeysGreen
        designableView.borderWidth = 2
    }
}
