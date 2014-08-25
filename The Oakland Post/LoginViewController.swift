//
//  LoginViewController.swift
//  The Oakland Post
//
//  Created by Andrew Clissold on 8/24/14.
//  Copyright (c) 2014 Andrew Clissold. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var scrollView: UIScrollView!

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    let defaultInsets = UIEdgeInsets(top: 0, left: 0, bottom: -170, right: 0)

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem =
            UIBarButtonItem(title: "Done", style: .Done, target: self, action: "dismiss")

        scrollView.contentInset = defaultInsets

        usernameTextField.delegate = self
        passwordTextField.delegate = self
    }

    func textFieldDidBeginEditing(textField: UITextField!) {
        UIView.animateWithDuration(0.3) {
            self.scrollView.contentInset = UIEdgeInsetsZero
            // TODO: compute these rather than hard-coding to iPhone 5s dimensions
            self.scrollView.scrollIndicatorInsets = UIEdgeInsets(top: 64, left: 0, bottom: 218, right: 0)
        }
    }

    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        if let nextResponder = textField.superview?.viewWithTag(textField.tag + 1) {
            nextResponder.becomeFirstResponder()
        } else if textField === passwordTextField {
            hideKeyboardAndLogIn()
        }

        return false
    }

    @IBAction func hideKeyboardAndLogIn() {
        findAndResignFirstResponder()
        UIView.animateWithDuration(0.3) {
            self.scrollView.contentInset = self.defaultInsets
            self.scrollView.scrollIndicatorInsets = UIEdgeInsetsZero
        }

        let username = usernameTextField.text
        let password = passwordTextField.text
        PFUser.logInWithUsernameInBackground(username, password: password) {
            [weak self] (user, error) in
            if user != nil {
                self?.dismiss()
            } else {
                if error.code == kPFErrorObjectNotFound {
                    p("invalid credentials") // TODO
                }
            }
        }
    }

    func findAndResignFirstResponder() {
        for textField in [usernameTextField, passwordTextField] {
            if textField.isFirstResponder() {
                textField.resignFirstResponder()
                return
            }
        }
    }

    func dismiss() {
        findAndResignFirstResponder()
        dismissViewControllerAnimated(true, completion: nil)
    }

}
