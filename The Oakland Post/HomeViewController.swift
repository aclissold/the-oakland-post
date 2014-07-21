//
//  Test.swift
//  The Oakland Post
//
//  Created by Andrew Clissold on 7/13/14.
//  Copyright (c) 2014 Andrew Clissold. All rights reserved.
//

import UIKit

class HomeViewController: PostTableViewController {

    var shouldScrollToTop = false

    override func viewDidLoad() {
        // http://goo.gl/jqzaQQ
        baseURL =
            "http://www.oaklandpostonline.com/search/?mode=article&q=&nsa=eedition" +
            "&t=article&s=start_time&sd=desc&f=rss" +
            "&c%5B%5D=news*%2Csports*%2Clife*%2Cbusiness*%2Copinion*%2Cspecial_sections*"

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
