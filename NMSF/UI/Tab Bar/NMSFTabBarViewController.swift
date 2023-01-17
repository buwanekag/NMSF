//
//  NMSFTabBarViewController.swift
//  NMSF
//
//  Created by Matt Stanford on 4/23/21.
//

import UIKit

class NMSFTabBarViewController: UITabBarController {
    
    var indicatorView: UIView?
    var tabFrames: [CGRect]?
    var indicatorCenterOffset: CGFloat?
    
    lazy private var locateVC: MapViewController = {
        let vm = MapViewModel()
        let vc = MapViewController(viewModel: vm, nibName: MapViewController.className, bundle: nil)
        vc.tabBarItem = UITabBarItem(title: "Locate", image: UIImage(named: "tab_locate"), selectedImage: nil)
        return vc
    }()
    
    lazy private var discoverVC: DiscoverViewController = {
        let vc = DiscoverViewController(nibName: DiscoverViewController.className, bundle: nil)
        vc.tabBarItem = UITabBarItem(title: "Discover", image: UIImage(named: "tab_discover"), selectedImage: nil)
        return vc
    }()
    
    lazy private var planVC: PlanViewController = {
        let vc = PlanViewController(nibName: PlanViewController.className, bundle: nil)
        vc.tabBarItem = UITabBarItem(title: "Plan", image: UIImage(named: "tab_plan"), selectedImage: nil)
        return vc
    }()
    
    lazy private var moreVC: MoreViewController = {
        let vm = MoreViewModel()
        let vc = MoreViewController(viewModel: vm, nibName: MoreViewController.className, bundle: nil)
        vc.tabBarItem = UITabBarItem(title: "More", image: UIImage(named: "tab_more"), selectedImage: nil)
        return vc
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewControllers = [locateVC, discoverVC, planVC, moreVC]
        setupFontsAndColors()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupTabIndicator()
    }

    /*
       HACK for early versions of iOS 13 (tested iOS 13.3).
    
       Early iOS 13 versions won't create a big enough label, and will truncate when a11y mode is on. This is part of the
        workaround discussed below to center the labels.
    */
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.tabBar.subviews.forEach { barButton in
            guard let label = barButton.subviews.compactMap({ $0 as? UILabel }).first else {
                return
            }
            label.textAlignment = .center
        }
    }

    private func setupFontsAndColors() {
        let appearance = tabBar.standardAppearance
        appearance.configureWithOpaqueBackground()
        appearance.shadowImage = nil
        appearance.shadowColor = nil
        appearance.stackedItemPositioning = .centered
        appearance.backgroundColor = .white

        setTabBarItemColors(appearance.stackedLayoutAppearance)
        setTabBarItemColors(appearance.inlineLayoutAppearance)
        setTabBarItemColors(appearance.compactInlineLayoutAppearance)

        tabBar.standardAppearance = appearance
        
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }

        /*
            HACK for early versions of iOS 13 (tested iOS 13.3).
         
            Early iOS 13 versions won't create a big enough label, and will truncate when a11y mode is on. The workaround here is
            to create a bigger label with UITabBarItem.appearance(), then the system will set the "real" font size in the tabBar.standardAppearnace (set above).
            This will create a label that is left-aligned, so we must center it in viewWillLayoutSubviews
        */
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: Constants.Color.primaryBlue, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)], for: .selected)

        self.tabBar.addShadow(offset: CGSize(width: 0, height: -4))
    }

    private func setTabBarItemColors(_ itemAppearance: UITabBarItemAppearance) {
        itemAppearance.normal.iconColor = UIColor.black
        itemAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10)]

        itemAppearance.selected.iconColor = Constants.Color.primaryBlue
        itemAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: Constants.Color.primaryBlue, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10)]
    }

    private func setupTabIndicator() {
        let tabFrames = getTabFrames()
        self.indicatorCenterOffset = getTabCenterOffset()
                
        guard tabFrames.count > 0,
            let indicatorCenterOffset = self.indicatorCenterOffset else {
            return
        }
        self.tabFrames = tabFrames

        let tabWidth = tabFrames[0].width
        let spaceBetweenTabs = tabFrames[1].origin.x - (tabFrames[0].origin.x + tabFrames[0].width)
        let tabHeight: CGFloat = tabBar.frame.height
        let indidicatorWidth = tabWidth + spaceBetweenTabs - abs(indicatorCenterOffset)

        let tabBarItemSize = CGSize(width: indidicatorWidth, height: tabHeight)

        if let currentIndicator = indicatorView {
            currentIndicator.removeFromSuperview()
            indicatorView = nil
        }
        indicatorView = UIView(frame: CGRect(x: 0, y: 0, width: tabBarItemSize.width, height: 2))
        indicatorView?.layer.cornerRadius = 4
        indicatorView?.clipsToBounds = true
        indicatorView?.backgroundColor = Constants.Color.primaryBlue

        setTabIndicatorPosition(index: self.selectedIndex)
        tabBar.addSubview(indicatorView!)
    }

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        UIView.animate(withDuration: 0.3) {
            guard let tabIndex = tabBar.items?.firstIndex(of: item) else {
                return
            }
            self.setTabIndicatorPosition(index: tabIndex)
        }
    }

    func select(tab: NMSFTabItem) {
        self.selectedIndex = tab.rawValue
        UIView.animate(withDuration: 0.3) {
            self.setTabIndicatorPosition(index: tab.rawValue)
        }
    }

    private func setTabIndicatorPosition(index: Int) {
        guard let indicatorCenterOffset = self.indicatorCenterOffset,
            let tabFrames = tabFrames,
            index <= tabFrames.count else {
            return
        }
        let tabWidth = tabFrames[index].width
        let xPosition = tabFrames[index].origin.x
        let centerX = xPosition + (tabWidth / 2) + indicatorCenterOffset
        self.indicatorView?.center.x = centerX
    }

    //Get the relative frames of the tab items so we can acuarately calculate where the selection indicator is positioned.
    func getTabFrames() -> [CGRect] {
        let frames: [CGRect] = self.tabBar.subviews.compactMap { return $0 is UIControl ? $0.frame : nil }

        let relativeFrames: [CGRect] = frames.map {
            return self.tabBar.convert($0, to: self.view)
        }

        return relativeFrames.sorted(by: { $0.origin.x < $1.origin.x })
    }
    /*
        When selected, the tab images are ever so slightly off (usually by a half point). This method computes the center-offset of the first tab item.
        It assumes the tab at index 0 is selected.
     */
    func getTabCenterOffset() -> CGFloat? {
        let tabViews = self.tabBar.subviews.compactMap { return $0 is UIControl ? $0 : nil }

        let relativeImages: [CGRect] = tabViews.compactMap { tabView in
            guard let imageView = tabView.subviews.first(where: { $0 is UIImageView }) else {
                return nil
            }
            return tabView.convert(imageView.frame, to: tabView)
        }

        let tabFrames = getTabFrames()
        guard tabFrames.count == relativeImages.count else {
            return nil
        }

        //Take the offset from the first tab, as it should be selected (offsets are different when selected)
        let frame = tabFrames[0]
        let tabWidth = frame.width
        let imageWidth = relativeImages[0].width
        let estimatedStartX: CGFloat = (tabWidth / 2.0) - (imageWidth / 2.0)
        let offset = relativeImages[0].origin.x - estimatedStartX

        return offset
    }

}
