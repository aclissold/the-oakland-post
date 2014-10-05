//
//  BlogsViewController.swift
//  The Oakland Post
//
//  Tab 4.
//
//  Similar to HomeViewController but without additional functionality.
//
//  Created by Andrew Clissold on 7/16/14.
//  Copyright (c) 2014 Andrew Clissold. All rights reserved.
//

import UIKit

class BlogsViewController: PostTableViewController, TopScrollable {

    var canScrollToTop = false

    override func viewDidLoad() {
        baseURL = "http://www.oaklandpostonline.com/search/?q=&t=article&c[]=blogs*"
        super.viewDidLoad()
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
}
