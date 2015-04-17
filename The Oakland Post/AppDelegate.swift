//
//  AppDelegate.swift
//  The Oakland Post
//
//  Sets up Parse, registers for remote notifications, and handles scroll-to-top for the tab bar.
//
//  Created by Andrew Clissold on 6/13/14.
//  Copyright (c) 2014 Andrew Clissold. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UITabBarControllerDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        var tabBarController = window!.rootViewController as! UITabBarController
        tabBarController.delegate = self

        theme()
        configureParse()
        registerForRemoteNotifications(application)
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)

        return true
    }

    func theme() {
        UITabBar.appearance().tintColor = oaklandPostBlue
        SVProgressHUD.setBackgroundColor(UIColor.clearColor())
        SVProgressHUD.setForegroundColor(oaklandPostBlue)
        SVProgressHUD.setRingThickness(5)
        SearchBarThemer.theme()
    }

    func configureParse() {
        let file = NSBundle.mainBundle().pathForResource("Keys", ofType: "plist")!
        let keys = NSDictionary(contentsOfFile: file)!
        Parse.setApplicationId(keys["applicationId"] as! String, clientKey: keys["clientKey"] as! String)
        PFACL.setDefaultACL(PFACL(), withAccessForCurrentUser: true)
    }

    func registerForRemoteNotifications(application: UIApplication!) {
        if application.respondsToSelector("registerUserNotificationSettings:") {
            // iOS 8+
            let userNotificationTypes = UIUserNotificationType.Alert | .Sound
            let notificationSettings = UIUserNotificationSettings(forTypes: userNotificationTypes, categories: nil)
            application.registerUserNotificationSettings(notificationSettings)
            application.registerForRemoteNotifications()
        } else {
            application.registerForRemoteNotificationTypes(.Alert | .Sound)
        }
    }

    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        // Notify Parse of the registration.
        let currentInstallation = PFInstallation.currentInstallation()
        currentInstallation.setDeviceTokenFromData(deviceToken)
        currentInstallation.channels = ["global"]
        currentInstallation.saveInBackground()
    }

    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        // Just show an alert when notifications are received in-app.
        PFPush.handlePush(userInfo)
    }

    // Scroll-to-top for child view controllers of the tab bar controller.
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
        let childViewController = viewController.childViewControllers[0] as! UIViewController

        if let topScrollable = childViewController as? TopScrollable {
            if topScrollable.canScrollToTop {
                topScrollable.scrollToTop()
            }
        }
    }

}
