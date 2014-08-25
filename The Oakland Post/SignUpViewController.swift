//
//  SignUpViewController.swift
//  The Oakland Post
//
//  Created by Andrew Clissold on 8/24/14.
//  Copyright (c) 2014 Andrew Clissold. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var scrollView: UIScrollView!

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!

    let defaultInsets = UIEdgeInsets(top: 0, left: 0, bottom: -170, right: 0)

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem =
            UIBarButtonItem(title: "Done", style: .Done, target: self, action: "dismiss:")

        scrollView.contentInset = defaultInsets

        usernameTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
        emailTextField.delegate = self
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
        } else if textField === emailTextField {
            hideKeyboardAndSignUp()
        }

        return false
    }

    @IBAction func hideKeyboardAndSignUp() {
        findAndResignFirstResponder()
        UIView.animateWithDuration(0.3) {
            self.scrollView.contentInset = self.defaultInsets
            self.scrollView.scrollIndicatorInsets = UIEdgeInsetsZero
        }

        let username = usernameTextField.text
        let password = passwordTextField.text
        // TODO: check == confirmPassword
        let email = emailTextField.text
        p("should log in with \(username), \(password), \(email)")
    }

    func findAndResignFirstResponder() {
        for textField in [usernameTextField, passwordTextField, confirmPasswordTextField, emailTextField] {
            if textField.isFirstResponder() {
                textField.resignFirstResponder()
                return
            }
        }
    }

    func dismiss(sender: UIButton) {
        findAndResignFirstResponder()
        dismissViewControllerAnimated(true, completion: nil)
    }

}
