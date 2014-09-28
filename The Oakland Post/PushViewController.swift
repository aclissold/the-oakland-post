//
//  PushViewController.swift
//  TheOaklandPost
//
//  Created by Andrew Clissold on 9/28/14.
//  Copyright (c) 2014 Andrew Clissold. All rights reserved.
//

class PushViewController: UIViewController, UIAlertViewDelegate {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var bottomLayoutConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        let sendButton = UIBarButtonItem(title: "Send", style: .Done, target: self, action: "confirmPush")
        navigationItem.rightBarButtonItem = sendButton
        textView.textContainerInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        registerForKeyboardNotifications()
    }

    func confirmPush() {
        let alertView = UIAlertView(title: "Are you sure?",
            message: "\n\(textView.text)", delegate: self,
            cancelButtonTitle: "Cancel", otherButtonTitles: "Send")
        alertView.show()
    }

    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == 1 {
            sendPush()
            textView.resignFirstResponder()
            navigationController!.popViewControllerAnimated(true)
        }
    }

    func sendPush() {
        PFCloud.callFunctionInBackground("push", withParameters: ["text": textView.text]) { (result, error) in
            if error != nil {
                showAlertForErrorCode(error.code)
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
        let keyboardHeight = (info[UIKeyboardFrameBeginUserInfoKey] as NSValue).CGRectValue().size.height
        let navBarHeight = navigationController?.navigationBar.frame.size.height ?? 44

        self.bottomLayoutConstraint.constant += (keyboardHeight - navBarHeight)
    }

    func keyboardWillHide(notification: NSNotification) {
        self.bottomLayoutConstraint.constant = 20
    }
}
