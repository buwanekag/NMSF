//
//  DiscoverHeaderView.swift
//  NMSF
//
//  Created by Matt Stanford on 4/23/21.
//

import UIKit

protocol DiscoverHeaderDelegate: AnyObject {
    func searched(for string: String)
}

class DiscoverHeaderView: UIView {
    
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var titleLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var greenHeaderTabView: UIView!
    @IBOutlet weak var searchContainerView: UIView!
    @IBOutlet weak var searchShadowView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var animalImageView: UIImageView!
    @IBOutlet weak var searchButton: UIButton!
    
    private var animalOpacityThreshold: CGFloat = 22
    private var _maxHeight: CGFloat?
    var searchIsActive: Bool = false
    
    weak var delegate: DiscoverHeaderDelegate?
    
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
        //Search field
        searchContainerView.layer.cornerRadius = 26
        searchContainerView.layer.borderWidth = 2
        searchContainerView.layer.borderColor = Constants.Color.primaryBlue.cgColor
        searchTextField.font = UIFont.preferredFont(forTextStyle: .body, weight: .regular)
        searchTextField.attributedPlaceholder = NSAttributedString(string: Constants.Discover.searchPlaceholder, attributes: [
            .foregroundColor: Constants.Color.primaryBlue,
            .font: UIFont.preferredFont(forTextStyle: .body, weight: .bold)
        ])
        searchTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        searchShadowView.layer.cornerRadius = 26
        searchShadowView.layer.borderWidth = 2
        searchShadowView.addShadow(color: Constants.Color.primaryBlue, opacity: 0.5, offset: CGSize(width: 0, height: 0), radius: 4)
        searchContainerView.accessibilityElements = [searchTextField!, searchButton!]
       
        
        //Set other fonts
        titleLabel.font = UIFont.preferredFont(forTextStyle: .title1, weight: .bold)
        infoLabel.font = UIFont.preferredFont(forTextStyle: .body, weight: .regular)
        
        setSearchState(active: searchIsActive)
    }

    /*
     Prevent specific views from blocking scroll, but allow user to use search field
     */
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let searchBarPoint = self.convert(point, to: searchContainerView)
        
        if searchContainerView.hitTest(searchBarPoint, with: event) != nil {
            return true
        } else {
            return false
        }
    }
}

extension DiscoverHeaderView: CollapsingHeaderViewType {
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

extension DiscoverHeaderView: UITextFieldDelegate {
    //MARK: Search
    
    @IBAction func searchButtonTapped() {
        if searchIsActive {
            searchTextField.text = ""
            delegate?.searched(for: "")
        } else {
            searchTextField.becomeFirstResponder()
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        setSearchState(active: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        setSearchState(active: false)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        delegate?.searched(for: textField.text ?? "")
    }
    
    func setSearchState(active: Bool) {
        if active {
            searchShadowView.isHidden = false
            searchButton.setImage(Constants.Image.closeX, for: .normal)
            searchButton.accessibilityLabel = Constants.Discover.searchClearA11yLabel
        } else {
            searchShadowView.isHidden = true
            searchButton.setImage(Constants.Image.searchGlass, for: .normal)
            searchButton.accessibilityLabel = Constants.Discover.searchButtonA11yLabel
        }
        
        searchIsActive = active
    }
}
