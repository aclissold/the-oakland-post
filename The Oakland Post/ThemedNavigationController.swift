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
        navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: sansSerifName, size: 17)]
        UIBarButtonItem.appearance().setTitleTextAttributes(
            [NSFontAttributeName: UIFont(name: sansSerifName, size: 17)],
            forState: .Normal)

        if (self.respondsToSelector("hidesBarsOnSwipe")) {
            // iOS 8+
            hidesBarsOnSwipe = true
            barHideOnSwipeGestureRecognizer.addTarget(self, action: "swipe:")
        }
    }

    func swipe(recognizer: UISwipeGestureRecognizer) {
        postViewControllerShouldHideStatusBar = navigationBar.frame.origin.y < 0
        UIView.animateWithDuration(0.2) {
            self.viewControllers.first!.setNeedsStatusBarAppearanceUpdate()
        }
    }

}
