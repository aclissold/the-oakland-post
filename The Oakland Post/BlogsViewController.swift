//
//  BlogsViewController.swift
//  The Oakland Post
//
//  Created by Andrew Clissold on 7/16/14.
//  Copyright (c) 2014 Andrew Clissold. All rights reserved.
//

import UIKit

class BlogsViewController: PostTableViewController {

    override func viewDidLoad() {
        baseURL = "http://www.oaklandpostonline.com/search/?mode=article&q=&t=article&sd=desc&c[]=blogs*&f=rss"
        super.viewDidLoad()
    }
}
