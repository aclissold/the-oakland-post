//
//  AppDelegate.swift
//  The Oakland Post
//
//  Created by Andrew Clissold on 6/13/14.
//  Copyright (c) 2014 Andrew Clissold. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UITabBarControllerDelegate {
                            
    var window: UIWindow?

    func application(application: UIApplication!, didFinishLaunchingWithOptions launchOptions: NSDictionary!) -> Bool {
        var tabBarController = window!.rootViewController as UITabBarController
        tabBarController.delegate = self
        UITabBar.appearance().tintColor = oaklandPostBlue

        SVProgressHUD.setBackgroundColor(UIColor.clearColor())
        SVProgressHUD.setForegroundColor(oaklandPostBlue)
        SVProgressHUD.setRingThickness(5)


        return true
    }

    func tabBarController(tabBarController: UITabBarController!, didSelectViewController viewController: UIViewController!) {
        let childViewController: AnyObject = viewController.childViewControllers[0]

        // Scroll to top if possible
        if let topScrollableViewController = childViewController as? HomeViewController {
            topScrollableViewController.scrollToTop()
        } else if let topScrollableViewController = childViewController as? PhotosViewController {
            topScrollableViewController.scrollToTop()
        } else if let topScrollableViewController = childViewController as? BlogsViewController {
            topScrollableViewController.scrollToTop()
        }
    }

}
