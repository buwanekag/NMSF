//
//  KeyboardAvoidingScrollViewController.swift
//  NMSF
//
//  Created by Matt Stanford on 4/26/21.
//

import UIKit

class KeyboardAvoidingScrollViewController: UIViewController {

    @IBOutlet weak var keyboardAvoidingScrollView: UIScrollView!

    var originalInsets: UIEdgeInsets?
    var tapGR: UITapGestureRecognizer?

    private var isShowing: Bool = false

    var keyboardShouldDismissOnTap: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardWillShow(notification: Notification) {
        if isShowing {
            return
        }

        let userInfo = notification.userInfo!
        let endFrameRect = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue

        let safeAreaBottomInset = view.safeAreaInsets.bottom

        let currentInsets = keyboardAvoidingScrollView.contentInset

        let insets = UIEdgeInsets(top: currentInsets.top, left: currentInsets.left, bottom: endFrameRect.size.height - safeAreaBottomInset, right: currentInsets.right)
        keyboardAvoidingScrollView.contentInset = insets
        keyboardAvoidingScrollView.scrollIndicatorInsets = insets

        self.originalInsets = currentInsets

        isShowing = true
       
        if keyboardShouldDismissOnTap {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
            self.view.addGestureRecognizer(tapGesture)
            self.tapGR = tapGesture
        }
        
    }

    @objc func keyboardWillHide(notification: Notification) {
        if !isShowing {
            return
        }

        keyboardAvoidingScrollView.contentInset = originalInsets ?? .zero
        keyboardAvoidingScrollView.scrollIndicatorInsets = originalInsets ?? .zero

        isShowing = false
        
        if keyboardShouldDismissOnTap, let tapGR = tapGR {
            self.view.removeGestureRecognizer(tapGR)
        }
    }

    @objc func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}

