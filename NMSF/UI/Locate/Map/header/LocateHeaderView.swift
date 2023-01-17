//
//  LocateHeaderView.swift
//  NMSF
//
//  Created by Buwaneka Galpoththawela on 5/11/21.
//

import Foundation
import UIKit

class LocateHeaderView: UIView {
  
    
    @IBOutlet weak var view: UIView!
    
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
       
    }
    
}


