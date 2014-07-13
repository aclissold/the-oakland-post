//
//  ThemedNavigationController.swift
//  The Oakland Post
//
//  Created by Andrew Clissold on 7/12/14.
//  Copyright (c) 2014 Andrew Clissold. All rights reserved.
//

import UIKit

class ThemedNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBar.barTintColor = oaklandPostBlue
        navigationBar.barStyle = .Black
    }

}
