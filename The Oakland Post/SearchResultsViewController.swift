//
//  SearchResultsViewController.swift
//  TheOaklandPost
//
//  Created by Andrew Clissold on 2/22/15.
//  Copyright (c) 2015 Andrew Clissold. All rights reserved.
//

class SearchResultsViewController: PostTableViewController, TopScrollable {

    var canScrollToTop = false
    var searchText = ""

    override func viewDidLoad() {
        baseURL = "http://www.oaklandpostonline.com/search/?q=\(searchText)&t=article"
        super.viewDidLoad()
    }

    // MARK: TopScrollable

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
