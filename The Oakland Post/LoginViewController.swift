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

        registerForKeyboardNotifications()
    }

    func registerForKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(
            self, selector: "keyboardDidShow:", name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(
            self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }

    func keyboardDidShow(notification: NSNotification) {
//        let info = notification.userInfo!
//        let size = (info[UIKeyboardFrameBeginUserInfoKey] as NSValue).CGRectValue().size
    }

    func keyboardWillHide(notification: NSNotification) {
    }

    var count = 0
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if (++count == 2) {
            let viewHeight = view.frame.size.height
            let viewWidth = view.frame.size.width
            let barHeight = navigationController.navigationBar.frame.size.height

            scrollView.contentSize = CGSize(width: viewWidth, height: viewHeight-barHeight)
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
