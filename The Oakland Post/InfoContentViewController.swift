//
//  InfoContentViewController.swift
//  The Oakland Post
//
//  Created by Andrew Clissold on 7/2/14.
//  Copyright (c) 2014 Andrew Clissold. All rights reserved.
//

import UIKit

class InfoContentViewController: UIViewController {

    @IBOutlet var titleLabel: UILabel

    var pageIndex: Int!
    var titleText: String!

    override func viewDidLoad() {
        titleLabel.text = titleText
    }

}
