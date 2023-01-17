//
//  AboutViewController.swift
//  NMSF
//
//  Created by Buwaneka Galpoththawela on 5/6/21.
//

import UIKit

class AboutAppViewController: UIViewController {
    
    @IBOutlet var headerView: SecondaryHeaderView!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var appNameLabel: UILabel!
    @IBOutlet var versionLabel: UILabel!
    @IBOutlet var appDescriptionLabel: UILabel!
    @IBOutlet var imageCreditTitleLabel: UILabel!
    @IBOutlet var imageCreditLabel: UILabel!
    @IBOutlet var softwarePackageTitleLabel: UILabel!
    @IBOutlet var softwarePackageStackView: UIStackView!
          
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.contentInset = headerView.recommendedContentInset
        
        titleLabel.font = UIFont.preferredFont(forTextStyle: .title1, weight: .bold)
        appNameLabel.font = UIFont.preferredFont(forTextStyle: .title3, weight: .regular)
        versionLabel.font = UIFont.preferredFont(forTextStyle: .subheadline, weight: .regular)
        appDescriptionLabel.font = UIFont.preferredFont(forTextStyle: .body, weight: .regular)
        imageCreditTitleLabel.font = UIFont.preferredFont(forTextStyle: .subheadline, weight: .bold)
        imageCreditLabel.font = UIFont.preferredFont(forTextStyle: .body, weight: .regular)
        softwarePackageTitleLabel.font = UIFont.preferredFont(forTextStyle: .subheadline, weight: .bold)
    
        softwarePackageStackView.arrangedSubviews.forEach { subView in
            guard let label = subView as? UILabel else {
                return
            }
            label.font = UIFont.preferredFont(forTextStyle: .body, weight: .regular)
        }
        
        setVersionString()
    }
    
    private func setVersionString() {
        let appVersionString: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        let buildNumber: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
        
        let versionString = "\(appVersionString) (\(buildNumber))"
        versionLabel.text = versionString

    }
    
    @IBAction func backTapped() {
        navigationController?.popViewController(animated: true)
    }
}
