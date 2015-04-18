//
//  Valid.swift
//  The Oakland Post
//
//  User input validation to be called before registering a new user. Not meant to be comprehensive,
//  just meant to catch common mistakes.
//
//  Created by Andrew Clissold on 8/27/14.
//  Copyright (c) 2014 Andrew Clissold. All rights reserved.
//

func valid(user: PFUser, confirmPassword: String) -> Bool {
    if count(user.username!) < 6 {
        return error("Your username must be at least six characters. Please choose a new one and try again.")
    }
    if user.username!.containsWhitespace {
        return error("Usernames cannot contain spaces. Please choose a new one and try again.")
    }
    if count(user.password!) < 6 {
        return error("Your password must be at least six characters. Please choose a new one and try again.")
    }
    if user.password!.containsWhitespace {
        return error("Passwords cannot contain spaces. Please choose a new one and try again.")
    }
    if user.password! != confirmPassword {
        return error("Your passwords must match. Please retype them and try again.")
    }
    if !validEmail(user.email!) {
        return error("Your email address appears to be invalid. Please correct any typos and try again.")
    }

    return true
}

private extension NSString {
    var containsWhitespace: Bool {
        let range = NSMakeRange(0, self.length)
        let whitespaceRange = self.rangeOfCharacterFromSet(NSCharacterSet.whitespaceCharacterSet(),
            options: .RegularExpressionSearch, range: range)
        return whitespaceRange.location != NSNotFound
    }
}

private func validEmail(email: String) -> Bool {
    let regex = "[^\\s]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*"
    let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
    return predicate.evaluateWithObject(email)
}

private func error(message: String) -> Bool {
    UIAlertView(title: "Error",
        message: message,
        delegate: nil,
        cancelButtonTitle: "OK").show()
    return false
}
