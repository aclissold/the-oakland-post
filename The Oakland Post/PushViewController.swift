//
//  PushViewController.swift
//  TheOaklandPost
//
//  Push functionality for authenticated users.
//
//  Created by Andrew Clissold on 9/28/14.
//  Copyright (c) 2014 Andrew Clissold. All rights reserved.
//

private enum AlertPurpose: Int {
    case PushConfirmation = 0
    case PasswordConfirmation = 1
}

class PushViewController: UIViewController, UIAlertViewDelegate {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var bottomLayoutConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        let sendButton = UIBarButtonItem(title: "Send", style: .Done, target: self, action: "confirmPush")
        sendButton.enabled = false
        textView.editable = false
        textView.selectable = false
        navigationItem.rightBarButtonItem = sendButton

        textView.textContainerInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)

        registerForKeyboardNotifications()
        confirmPassword("Please re-type your\npassword to continue.")
    }

    // MARK: Password Confirmation

    func confirmPassword(message: String) {
        let alertView = UIAlertView(title: "Confirm Password",
            message: message, delegate: self,
            cancelButtonTitle: "Cancel", otherButtonTitles: "Confirm")
        alertView.alertViewStyle = .PlainTextInput
        alertView.textFieldAtIndex(0)!.secureTextEntry = true
        alertView.tag = AlertPurpose.PasswordConfirmation.rawValue
        alertView.show()
    }

    func checkPassword(password: String) {
        let currentUser = PFUser.currentUser()!
        PFUser.logInWithUsernameInBackground(currentUser.username!, password: password) { (user, error) in
            if error != nil {
                self.confirmPassword("Confirmation failed. Please try again.")
            } else {
                self.navigationItem.rightBarButtonItem!.enabled = true
                self.textView.editable = true
                self.textView.selectable = true
            }
        }
    }

    // MARK: Push Confirmation

    func confirmPush() {
        let alertView = UIAlertView(title: "Are you sure?",
            message: "\(textView.text)", delegate: self,
            cancelButtonTitle: "Cancel", otherButtonTitles: "Send")
        alertView.tag = AlertPurpose.PushConfirmation.rawValue
        alertView.show()
    }

    func sendPush() {
        self.navigationItem.rightBarButtonItem!.enabled = false
        PFCloud.callFunctionInBackground("push", withParameters: ["message": textView.text]) { (result, error) in
            if error != nil {
                self.navigationItem.rightBarButtonItem!.enabled = true
                showAlertForErrorCode(error!.code)
            } else {
                self.textView.resignFirstResponder()
                self.navigationController!.popViewControllerAnimated(true)
            }
        }
    }

    // MARK: UIAlertViewDelegate

    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        let alertPurpose = AlertPurpose(rawValue: alertView.tag)!
        switch alertPurpose {
        case .PushConfirmation:
            if buttonIndex == 1 {
                sendPush()
            }
        case .PasswordConfirmation:
            let passwordTextField = alertView.textFieldAtIndex(0)!
            passwordTextField.resignFirstResponder()
            if buttonIndex == 0 {
                navigationController!.popViewControllerAnimated(true)
            } else if buttonIndex == 1 {
                checkPassword(passwordTextField.text)
            }
        }
    }

    // MARK: Keyboard Handling

    func registerForKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(
            self, selector: "keyboardDidShow:", name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(
            self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }

    func keyboardDidShow(notification: NSNotification) {
        let info = notification.userInfo!
        let keyboardHeight = (info[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue().size.height
        let navBarHeight = navigationController?.navigationBar.frame.size.height ?? 44

        self.bottomLayoutConstraint.constant += (keyboardHeight - navBarHeight)
    }

    func keyboardWillHide(notification: NSNotification) {
        self.bottomLayoutConstraint.constant = 20
    }
}
