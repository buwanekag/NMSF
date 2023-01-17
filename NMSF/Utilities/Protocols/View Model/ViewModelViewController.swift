//
//  ViewModelViewController.swift
//  NMSF
//
//  Created by Buwaneka Galpoththawela on 3/30/21.
//

import UIKit

typealias ViewModelViewController = UIViewController & ViewModelable

protocol ViewModelable {
    associatedtype ViewModelType: ViewModel

    var viewModel: ViewModelType! { get set }
}

extension ViewModelable where Self: UIViewController {
    init(viewModel: ViewModelType, nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.viewModel = viewModel
        loadViewIfNeeded()
    }

    static func new(viewModel vm: ViewModelType) -> Self {
        return Self(viewModel: vm, nibName: Self.className, bundle: Bundle.main)
    }
}
