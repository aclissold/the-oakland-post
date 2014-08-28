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

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem =
            UIBarButtonItem(title: "Done", style: .Done, target: self, action: "dismiss")

        usernameTextField.delegate = self
        passwordTextField.delegate = self
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        if UIDevice.currentDevice().userInterfaceIdiom != .Pad {
            registerForKeyboardNotifications()
        }
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
        let info = notification.userInfo!
        let keyboardHeight = (info[UIKeyboardFrameBeginUserInfoKey] as NSValue).CGRectValue().size.height
        let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.size.height
        let navBarHeight = navigationController.navigationBar.frame.size.height
        let top = statusBarHeight + navBarHeight
        let bottom = keyboardHeight

        let insets = UIEdgeInsets(top: top, left: 0, bottom: bottom, right: 0)
        UIView.animateWithDuration(0.3) {
            self.scrollView.contentInset = insets
            self.scrollView.scrollIndicatorInsets = insets
        }
    }

    func keyboardWillHide(notification: NSNotification) {
        let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.size.height
        let navBarHeight = navigationController.navigationBar.frame.size.height
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
            var navBarHeight = navigationController.navigationBar.frame.size.height

            if UIDevice.currentDevice().userInterfaceIdiom != .Pad {
                let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.size.height
                navBarHeight += statusBarHeight
            }

            scrollView.contentSize = CGSize(width: viewWidth, height: viewHeight-navBarHeight)
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
