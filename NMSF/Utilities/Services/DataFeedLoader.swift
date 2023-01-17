//
//  DataFeedLoader.swift
//  NMSF
//
//  Created by Buwaneka Galpoththawela on 4/15/21.
//

import Alamofire
import Combine
import CoreLocation

final class DataFeedLoader {
    static let shared: DataFeedLoader = DataFeedLoader()
    
    var siteNotifications = [SiteNotification]()
    let userDefaults = NMSFUserDefaults()
    let networkManager = NetworkManager()
    let coreDataManager = CoreDataManager()
    
    struct Connectivity {
        static let sharedInstance = NetworkReachabilityManager()!
        
        static var isConnectedToInternet: Bool {
            return sharedInstance.isReachable
        }
    }
    
    func refreshData() -> AnyPublisher<Void, Error> {
        Publishers.Zip(refreshSites(), refreshZones())
            .map { _ in }
            .eraseToAnyPublisher()
    }
    
    func isDataPersisted() -> AnyPublisher<Bool, Error> {
        let sitesLoadedPublisher = getSites()
            .map { !$0.isEmpty }
            .eraseToAnyPublisher()
        
        let zonesLoadedPublisher = getZones()
            .map { !$0.isEmpty }
            .eraseToAnyPublisher()
        
        return Publishers.Zip(sitesLoadedPublisher, zonesLoadedPublisher)
            .map { $0 && $1 }
            .eraseToAnyPublisher()
    }    
}

extension DataFeedLoader {
    func refreshSites() -> AnyPublisher<Void, Error> {
        networkManager
            .call(payloadType: JsonApiResponse<[SiteJsonPayload]>.self, endpoint: .sites)
            .map { jsonPayload -> [Site] in
                let itemPayloads = jsonPayload.data
                let includeMap = jsonPayload.includedMap
                let entities = itemPayloads.compactMap { $0.createEntity(coreDataManager: self.coreDataManager, includedMap: includeMap)}
                
                return entities
            }
            .flatMap { [weak self] sites -> AnyPublisher<Void, Error> in
                guard let `self` = self else {
                    return Fail(error: CoreDataError.unknown)
                        .eraseToAnyPublisher()
                }
                
                return self.coreDataManager.saveContext()
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    func getSites(predicate: NSPredicate? = nil) -> AnyPublisher<[Site], Error> {
        coreDataManager
            .fetchAll(ofType: Site.self, predicate: predicate)
            .eraseToAnyPublisher()
    }
    
    func refreshZones() -> AnyPublisher<Void, Error> {
        networkManager
            .call(payloadType: JsonApiResponse<[ZoneJsonPayload]>.self, endpoint: .zones)
            .map { jsonPayload -> [Zone]  in
                let itemPayloads = jsonPayload.data
                let includeMap = jsonPayload.includedMap
                
                let entities = itemPayloads.compactMap { $0.createEntity(coreDataManager: self.coreDataManager, includedMap: includeMap) }
                return entities
            }
            .flatMap { [weak self] zones -> AnyPublisher<Void, Error> in
                guard let `self` = self else {
                    return Fail(error: CoreDataError.unknown)
                        .eraseToAnyPublisher()
                }
                return self.coreDataManager.saveContext()
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    func getZones(predicate: NSPredicate? = nil) -> AnyPublisher<[Zone], Error> {
        coreDataManager
            .fetchAll(ofType: Zone.self, predicate: predicate)
            .eraseToAnyPublisher()
    }
}


extension DataFeedLoader {
    
    func saveNotifications() {
        // Will change geo fences prior to pushing to QA for testing
        let site2Coord = CLLocationCoordinate2D(latitude: 39.268751, longitude: -76.597401)
        let site1Coord = CLLocationCoordinate2D(latitude: 39.277132, longitude: -76.562201)
        let hershsBmore = CLLocationCoordinate2D(latitude: 39.27166, longitude: -76.61158)
        let schoolForBlindCoord = CLLocationCoordinate2D(latitude: 39.268736, longitude: -76.610284)
        let oldHam134Coord = CLLocationCoordinate2D(latitude: 39.290860, longitude: -76.556060)
        
        let oldHam300Coord = CLLocationCoordinate2D(latitude: 39.288970, longitude: -76.556140)
        let site1 = SiteNotification(coordinate: site1Coord, radius: Double(1000), identifier: NSUUID().uuidString, note: "Hello Diamondback Brews!", eventType: .onEntry)
        let site2 = SiteNotification(coordinate: site2Coord, radius: Double(1000), identifier: NSUUID().uuidString, note: "Hello From Kiddie Academy", eventType: .onEntry)
        let hershs = SiteNotification(coordinate: hershsBmore, radius: Double(10000), identifier: NSUUID().uuidString, note: "Hello From Hersh's", eventType: .onEntry)
        let schoolForBlind = SiteNotification(coordinate: schoolForBlindCoord, radius: Double(10000), identifier: NSUUID().uuidString, note: "Hello From the Blind Foundation", eventType: .onEntry)
        
        let oldHam134 = SiteNotification(coordinate: oldHam134Coord, radius: Double(10000), identifier: NSUUID().uuidString, note: "Hello From Oldham 134", eventType: .onEntry)
        
        let oldHam300 = SiteNotification(coordinate: oldHam134Coord, radius: Double(10000), identifier: NSUUID().uuidString, note: "Hello From Oldham 300", eventType: .onEntry)
        siteNotifications.append(site1)
        siteNotifications.append(site2)
        siteNotifications.append(hershs)
        siteNotifications.append(schoolForBlind)
        siteNotifications.append(oldHam134)
        siteNotifications.append(oldHam300)
        let hasAddedGeoFences = userDefaults.geoFencesStatus
        if !hasAddedGeoFences {
            userDefaults.saveSiteNotifications(sites:siteNotifications)
        }
    }
  
}
