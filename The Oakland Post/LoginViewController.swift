//
//  LoginViewController.swift
//  The Oakland Post
//
//  A simple login form.
//
//  Created by Andrew Clissold on 8/24/14.
//  Copyright (c) 2014 Andrew Clissold. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate, UIAlertViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var logInActivityIndicator: UIActivityIndicatorView!

    var notification: NSNotification?

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem =
            UIBarButtonItem(title: "Done", style: .Done, target: self, action: "dismiss:")

        usernameTextField.delegate = self
        passwordTextField.delegate = self
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        registerForKeyboardNotifications()
    }

    override func viewDidDisappear(animated: Bool) {
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

    func keyboardDidShow(notification: NSNotification) {
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            self.notification = notification
            return
        }
        let info = notification.userInfo!
        let keyboardHeight = (info[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue().size.height
        let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.size.height
        let navBarHeight = navigationController!.navigationBar.frame.size.height
        let top = statusBarHeight + navBarHeight
        let bottom = keyboardHeight

        let insets = UIEdgeInsets(top: top, left: 0, bottom: bottom, right: 0)
        UIView.animateWithDuration(0.3) {
            self.scrollView.contentInset = insets
            self.scrollView.scrollIndicatorInsets = insets
        }
    }

    func keyboardWillHide(notification: NSNotification) {
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            self.notification = nil
            return
        }
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
        if (++count == 2) {
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
        } else if textField === passwordTextField {
            hideKeyboardAndLogIn()
        }

        return false
    }

    @IBAction func hideKeyboardAndLogIn() {
        logInButton.enabled = false
        navigationItem.rightBarButtonItem!.enabled = false

        logInActivityIndicator.startAnimating()
        findAndResignFirstResponder()

        let username = usernameTextField.text
        let password = passwordTextField.text
        PFUser.logInWithUsernameInBackground(username, password: password) {
            (user, error) in
            if user != nil {
                self.dismiss(nil)
                homeViewController.tableView.reloadData()
                homeViewController.findStarredPosts()
            } else {
                showAlertForErrorCode(error!.code)
                self.logInButton.enabled = true
                self.navigationItem.rightBarButtonItem!.enabled = true
                self.logInActivityIndicator.stopAnimating()
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

    @IBAction func forgotPasswordTapped(sender: UIButton) {
        findAndResignFirstResponder()
        let alertView = UIAlertView(title: "Forgot Password", message: "Please enter your " +
            "email address. Instructions on how to reset your password will be sent there.",
            delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "Submit")
        alertView.alertViewStyle = .PlainTextInput
        alertView.textFieldAtIndex(0)!.keyboardType = .EmailAddress
        alertView.show()
    }

    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == 1 {
            let email = alertView.textFieldAtIndex(0)!.text
            PFUser.requestPasswordResetForEmailInBackground(email) { (success, error) in
                if !success { showAlertForErrorCode(error!.code) }
            }
        }
    }

    func dismiss(sender: UIBarButtonItem?) {
        findAndResignFirstResponder()
        if sender == nil {
            // Log In success (as opposed to Done button pressed)
            configureFavoritesButton()
        }
        dismissViewControllerAnimated(true, completion: nil)
    }

    func configureFavoritesButton() {
        let tabBarController = presentingViewController as! UITabBarController
        let navigationController = tabBarController.viewControllers![0] as! UINavigationController
        let homeViewController = navigationController.childViewControllers[0] as! HomeViewController
        homeViewController.navigationItem.rightBarButtonItem = homeViewController.favoritesBarButtonItem
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == signUpID {
            if notification != nil && UIDevice.currentDevice().userInterfaceIdiom == .Pad {
                let signUpViewController = segue.destinationViewController as! SignUpViewController
                signUpViewController.keyboardWasPresent = true
            }
        }
    }

}
