//
//  AccessibleByView.swift
//  NMSF
//
//  Created by Buwaneka Galpoththawela on 5/4/21.
//

import UIKit

class AccessibleByView: UIView {
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    let nibName = "AccessibleByView"
    var contentView: UIView?

    required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            commonInit()
        }
    override init(frame: CGRect) {
           super.init(frame: frame)
           commonInit()
       }

    func commonInit() {
        Bundle.main.loadNibNamed(className, owner: self, options: nil)
        view.frame = bounds
        addSubview(view)
        
        typeLabel.font = UIFont.preferredFont(forTextStyle: .body, weight: .regular)
    }


}
