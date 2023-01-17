//
//  UIViewController+Alerts.swift
//  NMSF
//
//  Created by Matt Stanford on 4/29/21.
//

import UIKit

extension UIViewController {
    
    func showAlert(title: String? = nil, message: String? = nil, onDismiss: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Constants.Common.ok, style: .default, handler: onDismiss))
        present(alert, animated: true, completion: nil)
    }

    func showError(_ message: String, onDismiss: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: Constants.Common.error, message: message, preferredStyle: .alert)


        alert.addAction(UIAlertAction(title: Constants.Common.ok, style: .default, handler: onDismiss))
        present(alert, animated: true, completion: nil)
    }

    func showConfirmationAlert(title: String? = nil,
                               message: String? = nil,
                               confirmButtonText: String,
                               confirmAction: ((UIAlertAction) -> Void)?,
                               cancelButtonText: String = Constants.Common.cancel,
                               cancelHandler: ((UIAlertAction) -> Void)? = nil) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: confirmButtonText, style: .default, handler: confirmAction))
        alert.addAction(UIAlertAction(title: cancelButtonText, style: .cancel, handler: cancelHandler))

        self.present(alert, animated: true, completion: nil)
    }
}
