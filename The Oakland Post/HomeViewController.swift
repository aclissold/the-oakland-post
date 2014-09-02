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

    override func viewDidLoad() {
        // http://goo.gl/jqzaQQ
        baseURL =
            "http://www.oaklandpostonline.com/search/?mode=article&q=&nsa=eedition" +
            "&t=article&s=start_time&sd=desc&f=rss" +
            "&c%5B%5D=news*%2Csports*%2Clife*%2Cbusiness*%2Copinion*%2Cspecial_sections*"

        if let user = PFUser.currentUser() {
            navigationItem.rightBarButtonItem = UIBarButtonItem(
                image: UIImage(named: "Favorites"), style: .Plain, target: self, action: "showFavorites")
        }

        super.viewDidLoad() // must be called after baseURL is set
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

    func showFavorites() {
        let favoritesViewController =
            UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(favoritesID) as FavoritesViewController
        navigationController.pushViewController(favoritesViewController, animated: true)
    }

}
