//
//  VendorProfileViewController.swift
//  NMSF
//
//  Created by Buwaneka Galpoththawela on 5/6/21.
//

import UIKit
import MapKit
class VendorProfileViewController: UIViewController, ViewModelable {

    var viewModel: VendorProfileViewModel!
    
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var telephoneNumberLabel: UILabel!
    @IBOutlet weak var telephoneTitleLabel: UILabel!
    @IBOutlet weak var websiteStackView: UIStackView!
    @IBOutlet weak var websiteTitleLabel: UILabel!
    @IBOutlet weak var websiteLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var getDirectionsButton: UIButton!
    @IBOutlet weak var descriptionTitleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        registerMapAnnotations()
        setupMapView()
    }

    func setupUI(){
        nameLabel.font = UIFont.preferredFont(forTextStyle: .title1, weight: .bold)
        ratingLabel.font = UIFont.preferredFont(forTextStyle: .subheadline, weight: .regular)
        addressLabel.font = UIFont.preferredFont(forTextStyle: .subheadline, weight: .regular)
        distanceLabel.font = UIFont.preferredFont(forTextStyle: .subheadline, weight: .bold)
        descriptionLabel.font = UIFont.preferredFont(forTextStyle: .headline, weight: .regular)
        telephoneNumberLabel.font = UIFont.preferredFont(forTextStyle: .headline, weight: .regular)
        getDirectionsButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline, weight: .bold)
        descriptionTitleLabel.font = UIFont.preferredFont(forTextStyle: .subheadline, weight: .bold)
        telephoneTitleLabel.font = UIFont.preferredFont(forTextStyle: .subheadline, weight: .bold)
        websiteTitleLabel.font = UIFont.preferredFont(forTextStyle: .subheadline, weight: .bold)
        websiteLabel.font = UIFont.preferredFont(forTextStyle: .headline, weight: .bold)
        closeButton.imageView?.tintColor = Constants.Color.primaryBlue
        
        ratingLabel.text = viewModel.profile?.rating
        nameLabel.text = viewModel.profile?.name
        addressLabel.text = viewModel.profile?.address
        distanceLabel.text = viewModel.profile?.distance
        descriptionLabel.text = viewModel.profile?.description
        telephoneNumberLabel.text = viewModel.profile?.phone
        websiteLabel.text = viewModel.profile?.website
        
        mapView.roundCorners(.allCorners, radius: 15)
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(goToWebSite))
        websiteStackView.addGestureRecognizer(tapGR)
        
    }
    
    @IBAction func closeButtonTapped(_: UIButton){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func goToWebSite() {
        guard let url = viewModel.webSiteURL else {
            return
        }
        UIApplication.shared.open(url)
    }
    
    @IBAction func tappedGetDirections() {
        guard let url = viewModel.directionsLink else {
            return
        }
        UIApplication.shared.open(url)
    }
}

extension VendorProfileViewController: MKMapViewDelegate {
    func registerMapAnnotations() {
        mapView.register(SiteAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
    }
    
    func setupMapView() {
        
        mapView.delegate = self
        mapView.isUserInteractionEnabled = false
        
        refreshMapAnnotations()
        setInitialMapRegion()
       
    }
    
    func refreshMapAnnotations() {
        guard let annotation = viewModel.annotation else {
            return
        }
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotation(annotation)
    }
    
    func setInitialMapRegion() {
        guard let coordinate = viewModel.location?.coordinate else {
            return
        }
        mapView.mapType = MKMapType.standard

        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: true)
        
    }
}
