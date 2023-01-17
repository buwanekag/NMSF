//
//  POISearchHeader.swift
//  NMSF
//
//  Created by Buwaneka Galpoththawela on 5/19/21.
//

import Foundation
import UIKit

protocol POISearchHeaderDelegate: AnyObject {
    func searched(for string: String)
}

class POISearchHeader: UIView {
    @IBOutlet weak var view: UIView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet weak var searchContainerView: UIView!
    @IBOutlet weak var searchShadowView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    
    var searchIsActive: Bool = false
    
    weak var delegate: POISearchHeaderDelegate?
    
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
        
       // setupUI()
    }
    func setupUI(title: String, placeholder: String) {
        
        //Search field
        searchContainerView.layer.cornerRadius = 26
        searchContainerView.layer.borderWidth = 2
        searchContainerView.layer.borderColor = Constants.Color.primaryBlue.cgColor
        searchTextField.font = UIFont.preferredFont(forTextStyle: .body, weight: .regular)
        searchTextField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [
            .foregroundColor: Constants.Color.primaryBlue,
            .font: UIFont.preferredFont(forTextStyle: .body, weight: .bold)
        ])
        searchTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        searchShadowView.layer.cornerRadius = 26
        searchShadowView.layer.borderWidth = 2
        searchShadowView.addShadow(color: Constants.Color.primaryBlue, opacity: 0.5, offset: CGSize(width: 0, height: 0), radius: 4)
        searchContainerView.accessibilityElements = [searchTextField!, searchButton!]
        
        
        //Set other fonts
        titleLabel.text = title
        titleLabel.font = UIFont.preferredFont(forTextStyle: .title1, weight: .bold)
        
        
        setSearchState(active: searchIsActive)
    }
}


extension POISearchHeader: UITextFieldDelegate {
    
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
