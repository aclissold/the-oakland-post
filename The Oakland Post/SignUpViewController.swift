//
//  SignUpViewController.swift
//  The Oakland Post
//
//  A simple signup form.
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

    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var signUpActivityIndicator: UIActivityIndicatorView!

    var keyboardWasPresent = false

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem =
            UIBarButtonItem(title: "Done", style: .Done, target: self, action: "dismiss")

        usernameTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
        emailTextField.delegate = self

    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        if UIDevice.currentDevice().userInterfaceIdiom != .Pad {
            registerForKeyboardNotifications()
        }
    }

    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(
            self, name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(
            self, name: UIKeyboardWillHideNotification, object: nil)
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        findAndResignFirstResponder()
    }

    func registerForKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(
            self, selector: "keyboardDidShow:", name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(
            self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }

    var insets = UIEdgeInsetsZero
    func keyboardDidShow(notification: NSNotification) {
        if navigationController == nil {
            // Occurs when a screen edge pan gesture is initiated but canceled,
            // so insets will already have been set.
            scrollView.contentInset = insets
            scrollView.scrollIndicatorInsets = insets
            return
        }
        let info = notification.userInfo!
        let keyboardHeight = (info[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue().size.height
        let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.size.height
        let navBarHeight = navigationController!.navigationBar.frame.size.height
        let top = statusBarHeight + navBarHeight
        let bottom = keyboardHeight

        insets = UIEdgeInsets(top: top, left: 0, bottom: bottom, right: 0)
        UIView.animateWithDuration(0.3) {
            self.scrollView.contentInset = self.insets
            self.scrollView.scrollIndicatorInsets = self.insets
        }
    }

    func keyboardWillHide(notification: NSNotification) {
        if navigationController == nil { return } // avoid crash
        let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.size.height
        let navBarHeight = navigationController!.navigationBar.frame.size.height
        let top = statusBarHeight + navBarHeight
        let insets = UIEdgeInsets(top: top, left: 0, bottom: 0, right: 0)
        scrollView.contentInset = insets
        scrollView.scrollIndicatorInsets = insets
    }

    var count = 0
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if ++count == 2 || (count == 4 && keyboardWasPresent) {
            let viewHeight = view.frame.size.height
            let viewWidth = view.frame.size.width
            var navBarHeight = navigationController!.navigationBar.frame.size.height

            if UIDevice.currentDevice().userInterfaceIdiom != .Pad {
                let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.size.height
                navBarHeight += statusBarHeight
            }

            scrollView.contentSize = CGSize(width: viewWidth, height: viewHeight-navBarHeight)
        }
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if let nextResponder = textField.superview?.viewWithTag(textField.tag + 1) {
            nextResponder.becomeFirstResponder()
        } else if textField === emailTextField {
            hideKeyboardAndSignUp()
        }

        return false
    }

    @IBAction func hideKeyboardAndSignUp() {
        findAndResignFirstResponder()
        signUpButton.enabled = false
        signUpActivityIndicator.startAnimating()

        var user = PFUser()
        user.username = usernameTextField.text
        user.password = passwordTextField.text
        user.email = emailTextField.text
        let confirmPassword = confirmPasswordTextField.text

        if valid(user, confirmPassword) {
            user.signUpInBackgroundWithBlock {
                (succeeded, error) in
                if succeeded {
                    homeViewController.reloadData()
                    homeViewController.navigationItem.rightBarButtonItem =
                        homeViewController.favoritesBarButtonItem
                    self.dismiss()
                } else {
                    showAlertForErrorCode(error!.code)
                    self.signUpActivityIndicator.stopAnimating()
                    self.signUpButton.enabled = true
                }
            }
        } else {
            self.signUpActivityIndicator.stopAnimating()
            self.signUpButton.enabled = true
        }
    }

    func findAndResignFirstResponder() {
        for textField in [usernameTextField, passwordTextField, confirmPasswordTextField, emailTextField] {
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
