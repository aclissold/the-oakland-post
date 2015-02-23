//
//  LinkAlertDelegate.swift
//  The Oakland Post
//
//  Confirmation before opening a link in Safari.
//
//  Created by Andrew Clissold on 7/20/14.
//  Copyright (c) 2014 Andrew Clissold. All rights reserved.
//

class LinkAlertDelegate: NSObject, UIAlertViewDelegate {

    enum Button: Int {
        case No = 0
        case Yes
    }

    let URL: NSURL

    init(URL: NSURL) {
        self.URL = URL
    }

    func alertView(alertView: UIAlertView, didDismissWithButtonIndex buttonIndex: Int) {
        if Button(rawValue: buttonIndex)! == .Yes {
            UIApplication.sharedApplication().openURL(URL)
        }
    }
}
