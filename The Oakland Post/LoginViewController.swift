//
//  LoginViewController.swift
//  The Oakland Post
//
//  Created by Andrew Clissold on 8/24/14.
//  Copyright (c) 2014 Andrew Clissold. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem =
            UIBarButtonItem(title: "Done", style: .Done, target: self, action: "dismiss:")
    }

    func dismiss(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }

}
