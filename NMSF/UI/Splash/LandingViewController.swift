//
//  LandingViewController.swift
//  NMSF
//
//  Created by Buwaneka Galpoththawela on 3/29/21.
//

import CoreLocation
import UIKit

class LandingViewController: UIViewController {
    
    @IBOutlet private var bottomPresenter: UIView!
    @IBOutlet private var titleContainer: DesignableView!
    @IBOutlet private var foundationLogoImageView: UIImageView!
    @IBOutlet private var sanctuaryLogoImageView: UIImageView!
    @IBOutlet private var manateesImageView: UIImageView!
    
    @IBOutlet private weak var shadowView: UIView!
    @IBOutlet private weak var aboutAppCard: UIView!
    @IBOutlet private weak var imageContainer: UIView!
    @IBOutlet private weak var newIndicatorLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    
    @IBOutlet weak var disoverContainer: GradientView!
    @IBOutlet weak var discoverLabel: UILabel!
    
    let locationManager = LocationManager.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self

        setupCardView()
        setupDiscoverButton()
        performAnimations()
        authorizeNotifications()
    }
    
    // MARK: - Button Actions
    
    @IBAction func aboutAppTapped(_ sender: UIButton) {
        print("about app tapped")
    }
    
    @IBAction func onDiscoverSanctuaryTapped(_ sender: UIButton) {
        let tabBarController = NMSFTabBarViewController()
        navigationController?.pushViewController(tabBarController, animated: false)
    }
    
    @IBAction func privacyButtonTapped(_ sender: UIButton) {
        print("privacy button tapped")
    }
    
    func setupCardView() {
        aboutAppCard.layer.cornerRadius = 20
        aboutAppCard.layer.borderWidth = 2
        aboutAppCard.layer.borderColor = Constants.Color.floridaKeysGreen.cgColor
        
        shadowView.addShadow(opacity: 0.15, offset: CGSize(width: 4, height: 4), radius: 8)
        
        titleLabel.font = UIFont.preferredFont(forTextStyle: .body, weight: .bold)
        
        newIndicatorLabel.font = UIFont.preferredFont(forTextStyle: .subheadline, weight: .bold)
        
        imageContainer.layer.cornerRadius = imageContainer.frame.height / 2
    }
    
    func setupDiscoverButton() {
        let exploreGradientEndColor = UIColor(red: 0.137, green: 0.18, blue: 0.514, alpha: 1).cgColor
        
        disoverContainer.colors = [ Constants.Color.primaryBlue.cgColor, exploreGradientEndColor]
        disoverContainer.direction = .horizontal

        discoverLabel.font = UIFont.preferredFont(forTextStyle: .body, weight: .bold)
    }
    
    func performAnimations() {
        bottomPresenter.alpha = 0
        titleContainer.alpha = 0
        foundationLogoImageView.alpha = 0
        sanctuaryLogoImageView.alpha = 0
        
        UIView.animate(withDuration: 1, delay: 1, options: .curveEaseIn, animations: {
            self.titleContainer.alpha = 1
            self.foundationLogoImageView.alpha = 1
            self.sanctuaryLogoImageView.alpha = 1
        }) { _ in
            self.titleContainer.alpha = 0
            self.foundationLogoImageView.alpha = 0
            self.sanctuaryLogoImageView.alpha = 0
        }
       
        UIView.animate(withDuration: 1, delay: 2, options: .curveLinear, animations: {
            self.bottomPresenter.frame.origin.y = self.view.frame.minY
            self.bottomPresenter.alpha = 1
        })
        
        UIView.animate(withDuration: 1, delay: 4, options: .curveEaseIn, animations: {
            self.manateesImageView.alpha = 1
        })
    }
    
    func authorizeNotifications() {
        let options: UNAuthorizationOptions = [.badge, .sound, .alert]
        let center = UNUserNotificationCenter.current()

        center.requestAuthorization(options: options) { _, error in
            if let error = error {
                print("error requesting notification authorization: \(error)")
            }

            self.locationManager.startLocationServices()
        }
    }
}

extension LandingViewController: LocationDelegate {
    func gotUpdated(userLocation: CLLocation) {
        // TODO: eliminated this need to implement unused delegate method
        // Included to present follow up location alert
    }
}
