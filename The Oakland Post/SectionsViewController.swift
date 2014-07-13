//
//  SectionsViewController.swift
//  The Oakland Post
//
//  Created by Andrew Clissold on 7/12/14.
//  Copyright (c) 2014 Andrew Clissold. All rights reserved.
//

import UIKit

class SectionsViewController: UITableViewController {

    let titles = ["News", "Life", "Sports", "Arts & Entertainment", "Opinion", "Satire"]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Theme
        self.navigationController.navigationBar.barTintColor = oaklandPostBlue
        self.navigationController.navigationBar.barStyle = .Black

    }

    // MARK: UITableViewDataSource

    override func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }

    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell? {
        let cell = tableView.dequeueReusableCellWithIdentifier(sectionsCellID, forIndexPath: indexPath) as SectionsCell

        cell.titleLabel.text = titles[indexPath.row]

        return cell
    }

}
