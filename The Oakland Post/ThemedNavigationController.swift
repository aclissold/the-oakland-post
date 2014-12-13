//
//  ThemedNavigationController.swift
//  The Oakland Post
//
//  Theming that might otherwise have been performed in each of the many UINavigationController subclasses.
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
        navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: sansSerifName, size: 17)!]
        UIBarButtonItem.appearance().setTitleTextAttributes(
            [NSFontAttributeName: UIFont(name: sansSerifName, size: 17)!],
            forState: .Normal)
    }

}
