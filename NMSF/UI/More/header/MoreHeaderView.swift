//
//  MoreHeaderView.swift
//  NMSF
//
//  Created by Buwaneka Galpoththawela on 5/5/21.
//

import Foundation
import UIKit

class MoreHeaderView: UIView {
    
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var titleLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var animalImageView: UIImageView!
    
    private var animalOpacityThreshold: CGFloat = 22
    private var _maxHeight: CGFloat?
    
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
        
        setupUI()
    }
    
    private func setupUI() {
        titleLabel.font = UIFont.preferredFont(forTextStyle: .title1, weight: .bold)
    }
}

extension MoreHeaderView: CollapsingHeaderViewType {
    //MARK: Collapsing header methods

    var maxHeight: CGFloat {
        return _maxHeight ?? 0
    }

    var minHeight: CGFloat {
        return 110
    }
    
    var needsHeightInitialization: Bool {
        return _maxHeight == nil
    }
    
    func initializeMaxHeight(containerView: CollapsingToolbarVCType) {
        guard _maxHeight == nil else {
            //Already initialized
            return
        }

        let maxHeight = self.frame.height

        var modifiedInsets = containerView.scrollView.contentInset
        modifiedInsets.top = maxHeight
        containerView.scrollView.contentInset = modifiedInsets
        
        //The header should (hopefully) cover the safe area insets, so we don't need this
        containerView.scrollView.contentInsetAdjustmentBehavior = .never

        self._maxHeight = maxHeight

        /*
         This constraint was only used to determine the initial max size, keeping it will cause weird effects when the header is collapsing
         */
        NSLayoutConstraint.deactivate([titleLabelTopConstraint!])
    }
    
    func changedHeight(newHeight: CGFloat) {
        changeAnimalOpacity(newHeight: newHeight)
    }
    
    private func changeAnimalOpacity(newHeight: CGFloat) {
        let heightChangeAmount = min(maxHeight - newHeight, animalOpacityThreshold)
        let alphaAmount = 1 - (heightChangeAmount / animalOpacityThreshold)
        animalImageView.alpha = alphaAmount
    }
}
