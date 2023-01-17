//
//  PlanHeaderView.swift
//  NMSF
//
//  Created by Matt Stanford on 4/27/21.
//

import UIKit

protocol PlanHeaderDelegate: AnyObject {
    func selectedSegment(index: Int)
}

class PlanHeaderView: UIView {

    @IBOutlet weak var view: UIView!
    @IBOutlet weak var titleLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var animalImageView: UIImageView!
    
    private var animalOpacityThreshold: CGFloat = 22
    private var _maxHeight: CGFloat?
    
    weak var delegate: PlanHeaderDelegate?
    
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
        setupSegmentedControl()
    }
    
    /*
     Prevent specific views from blocking scroll, but allow user to use segmented control
     */
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let segmentedControlPoint = self.convert(point, to: segmentedControl)
        
        if segmentedControl.hitTest(segmentedControlPoint, with: event) != nil {
            return true
        } else {
            return false
        }
    }
    
    private func setupSegmentedControl() {
        
        //Font
        let selectedAtrributes: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.foregroundColor: Constants.Color.darkBlue,
            NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .subheadline, weight: .bold, maxSize: 15)]
        
        let unselectedAttributes: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .subheadline, weight: .bold, maxSize: 15)]
        
        
        segmentedControl.setTitleTextAttributes(selectedAtrributes, for: .selected)
        segmentedControl.setTitleTextAttributes(unselectedAttributes, for: .normal)
        segmentedControl.setTitleTextAttributes(unselectedAttributes, for: .highlighted)
        
        //Background
        segmentedControl.backgroundColor = Constants.Color.primaryBlue
    }
    
    @IBAction func segmentedControlChanged() {
        let selectedSegment = segmentedControl.selectedSegmentIndex
        delegate?.selectedSegment(index: selectedSegment)
    }
}

extension PlanHeaderView: CollapsingHeaderViewType {
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
