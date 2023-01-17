//
//  VendorProfileViewModel.swift
//  NMSF
//
//  Created by Buwaneka Galpoththawela on 5/6/21.
//


import Foundation
import MapKit

class VendorProfileViewModel: ViewModel {
    let profile: VendorProfile?
    var locationManager = LocationManager.shared
    
    init(profile: VendorProfile) {
        self.profile = profile
    }
    
    var webSiteURL: URL? {
        guard let urlString = profile?.website else {
            return nil
        }
        return URL(string: urlString)
    }
    
    var location: CLLocation? {
        //TODO: Remove this once we get data
        let fakeLocation = CLLocation(latitude: 24.545316259196365, longitude: -81.7833915543361)
        return fakeLocation
    }
    
    var annotation: MKPointAnnotation? {
        guard let location = location else {
            return nil
        }
        let annotation = MKPointAnnotation()
        annotation.coordinate = location.coordinate
        return annotation
    }
    
    var directionsLink: URL? {
        guard let destination = location,
            let userLocation = locationManager.lastUserLocation else {
            return nil
        }
        let urlString = "https://maps.google.com/?saddr=\(userLocation.coordinate.latitude),\(userLocation.coordinate.longitude)&daddr=\(destination.coordinate.latitude),\(destination.coordinate.longitude)"
        
        return URL(string: urlString)
    }
}
