//
//  Test.swift
//  The Oakland Post
//
//  Created by Andrew Clissold on 7/13/14.
//  Copyright (c) 2014 Andrew Clissold. All rights reserved.
//

import UIKit

class HomeViewController: PostTableViewController, TopScrollable {

    var canScrollToTop = false
    var logInBarButtonItem, favoritesBarButtonItem: UIBarButtonItem!

    override func viewDidLoad() {
        // http://goo.gl/jqzaQQ
        baseURL =
            "http://www.oaklandpostonline.com/search/?mode=article&q=&nsa=eedition" +
            "&t=article&s=start_time&sd=desc&f=rss" +
            "&c%5B%5D=news*%2Csports*%2Clife*%2Cbusiness*%2Copinion*%2Cspecial_sections*"

        logInBarButtonItem = UIBarButtonItem(title: "Log In", style: .Bordered, target: self, action: "logIn")
        favoritesBarButtonItem = UIBarButtonItem(image: UIImage(named: "Favorites"), style: .Bordered, target: self, action: "showFavorites")

        if let user = PFUser.currentUser() {
            navigationItem.rightBarButtonItem = favoritesBarButtonItem
        } else {
            navigationItem.rightBarButtonItem = logInBarButtonItem
        }

        super.viewDidLoad() // must be called after baseURL is set
    }

    override func viewDidLayoutSubviews() {
        if logInBarButtonItem == nil && navigationItem?.rightBarButtonItem?.title == "Log In" {
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
        let favoritesViewController =
            UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(favoritesID) as FavoritesViewController
        navigationController.pushViewController(favoritesViewController, animated: true)
    }

}
