//
//  BlogsViewController.swift
//  The Oakland Post
//
//  Created by Andrew Clissold on 7/16/14.
//  Copyright (c) 2014 Andrew Clissold. All rights reserved.
//

import UIKit

class BlogsViewController: PostTableViewController {

    var shouldScrollToTop = false

    override func viewDidLoad() {
        baseURL = "http://www.oaklandpostonline.com/search/?mode=article&q=&t=article&sd=desc&c[]=blogs*&f=rss"
        super.viewDidLoad()
    }

    override func viewDidAppear(animated: Bool) {
        shouldScrollToTop = true
    }

    override func viewDidDisappear(animated: Bool) {
        shouldScrollToTop = false
    }

    func scrollToTop() {
        if shouldScrollToTop {
            let rect = CGRect(origin: CGPointZero, size: CGSize(width: 1, height: 1))
            tableView.scrollRectToVisible(rect, animated: true)
        }
    }
}
