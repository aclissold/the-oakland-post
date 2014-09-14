//
//  Test.swift
//  The Oakland Post
//
//  Created by Andrew Clissold on 7/13/14.
//  Copyright (c) 2014 Andrew Clissold. All rights reserved.
//

import UIKit

var homeViewController: HomeViewController!

class HomeViewController: PostTableViewController, TopScrollable {

    var canScrollToTop = false
    var logInBarButtonItem, favoritesBarButtonItem: UIBarButtonItem!

    override func viewDidLoad() {
        SVProgressHUD.show()

        baseURL = "http://www.oaklandpostonline.com/search/?t=article"

        logInBarButtonItem = UIBarButtonItem(title: "Log In", style: .Bordered, target: self, action: "logIn")
        favoritesBarButtonItem = UIBarButtonItem(image: UIImage(named: "Favorites"), style: .Bordered, target: self, action: "showFavorites")

        homeViewController = self
        if let user = PFUser.currentUser() {
            navigationItem.rightBarButtonItem = favoritesBarButtonItem
        } else {
            navigationItem.rightBarButtonItem = logInBarButtonItem
        }

        if PFUser.currentUser() != nil { findStarredPosts() }

        super.viewDidLoad() // must be called after baseURL is set

    }

    func findStarredPosts() {
        let maxQueryLimit = 1000
        let query = PFQuery(className: "Item")
        query.limit = maxQueryLimit
        query.findObjectsInBackgroundWithBlock { (objects, error) in
            if error != nil {
                showAlertForErrorCode(error.code)
            } else {
                starredPosts = objects
                self.tableView.reloadData()
            }
        }
    }


    override func viewDidLayoutSubviews() {
        if logInBarButtonItem == nil && navigationItem.rightBarButtonItem?.title == "Log In" {
            logInBarButtonItem = navigationItem.rightBarButtonItem
        }
    }

    override func viewDidAppear(animated: Bool) {
        canScrollToTop = true
    }

    override func viewDidDisappear(animated: Bool) {
        canScrollToTop = false
    }

    func scrollToTop() {
        let rect = CGRect(origin: CGPointZero, size: CGSize(width: 1, height: 1))
        tableView.scrollRectToVisible(rect, animated: true)
    }

    func logIn() {
        performSegueWithIdentifier(logInID, sender: self)
    }

    func showFavorites() {
        let favoritesViewController = storyboard!.instantiateViewControllerWithIdentifier(favoritesID) as FavoritesViewController
        navigationController!.pushViewController(favoritesViewController, animated: true)
    }

    func unwindToHomeViewController() {
        // Called from InfoViewController.
        dismissViewControllerAnimated(true, completion: nil)
    }

}
