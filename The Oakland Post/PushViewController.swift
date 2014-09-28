//
//  PushViewController.swift
//  TheOaklandPost
//
//  Created by Andrew Clissold on 9/28/14.
//  Copyright (c) 2014 Andrew Clissold. All rights reserved.
//

class PushViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var bottomLayoutConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        let sendButton = UIBarButtonItem(title: "Send", style: .Done, target: self, action: "sendPush")
        navigationItem.rightBarButtonItem = sendButton
        textView.textContainerInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        registerForKeyboardNotifications()
    }

    func sendPush() {
        p(textView.text)
        textView.resignFirstResponder()
        navigationController!.popViewControllerAnimated(true)
    }

    // MARK: Keyboard Handling

    func registerForKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(
            self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(
            self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }

    func keyboardWillShow(notification: NSNotification) {
        let info = notification.userInfo!
        let keyboardHeight = (info[UIKeyboardFrameBeginUserInfoKey] as NSValue).CGRectValue().size.height
        let navBarHeight = navigationController!.navigationBar.frame.size.height

        UIView.animateWithDuration(0.3) {
            self.bottomLayoutConstraint.constant += (keyboardHeight - navBarHeight)
        }
    }

    func keyboardWillHide(notification: NSNotification) {
        UIView.animateWithDuration(0.3) {
            self.bottomLayoutConstraint.constant = 20
        }
    }
}
