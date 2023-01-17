//
//  SplashViewController.swift
//  NMSF
//
//  Created by Buwaneka Galpoththawela on 7/9/21.
//

import Combine
import UIKit
import Lottie

class SplashViewController: UIViewController {
    let dataFeedLoader = DataFeedLoader.shared
    var disposeBag = [AnyCancellable]()
    
    @IBOutlet weak var animationView: AnimationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAnimationView()
        sendToAppropriateScreen()
        dataFeedLoader.saveNotifications()
    }
   
    private func setupAnimationView() {
        let animation = Animation.named("splash_loader")
        animationView.animation = animation
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.animationSpeed = 1
        animationView.play()
    }
    
    private func sendToAppropriateScreen() {
        dataFeedLoader.isDataPersisted()
            .receive(on: DispatchQueue.main)
            .sink { result in
                if case let .failure(error) = result {
                    print("failed to retrieve from Core Data: \(error)")
                }
            } receiveValue: { [weak self] isPersisted in
                isPersisted ? self?.sendToHome() : self?.refreshData()
            }
            .store(in: &disposeBag)
    }
    
    private func refreshData() {
        print("loading data from network...")
        
        dataFeedLoader.refreshData()
            .receive(on: DispatchQueue.main)
            .sink { result in
                if case let .failure(error) = result {
                    print("failed to load data from network: \(error)")
                }
            } receiveValue: { [weak self] in
                self?.sendToLanding()
            }
            .store(in: &disposeBag)
    }
    
    func sendToHome() {
        print("successfully loaded from Core Data")
        
        let tabBarController = NMSFTabBarViewController()
        navigationController?.pushViewController(tabBarController, animated: true)
    }
    
    func sendToLanding() {
        print("successfully loaded data from network")
        
        let landingViewController = LandingViewController()
        navigationController?.pushViewController(landingViewController, animated: false)
    }
    
}
