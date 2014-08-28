//
//  Valid.swift
//  The Oakland Post
//
//  Created by Andrew Clissold on 8/27/14.
//  Copyright (c) 2014 Andrew Clissold. All rights reserved.
//

func valid(user: PFUser, confirmPassword: String) -> Bool {
    p(user.username)
    if user.password != confirmPassword {
        return error("Your passwords must match. Please re-type them and try again.")
    }
    p(user.email)

    return true
}

private func error(message: String) -> Bool {
    UIAlertView(title: "Error",
        message: message,
        delegate: nil,
        cancelButtonTitle: "OK").show()
    return false
}
