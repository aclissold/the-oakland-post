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
        let childViewController = viewController.childViewControllers[0] as UIViewController

        if let topScrollable = childViewController as? TopScrollable {
            if topScrollable.canScrollToTop {
                topScrollable.scrollToTop()
            }
        }
    }

}
