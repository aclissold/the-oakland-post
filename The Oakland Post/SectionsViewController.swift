//
//  SectionsViewController.swift
//  The Oakland Post
//
//  Tab 2.
//
//  A simple list of sections leading to their respective PostTableViewController instances.
//
//  Created by Andrew Clissold on 7/12/14.
//  Copyright (c) 2014 Andrew Clissold. All rights reserved.
//

import UIKit

private let prefix = "http://www.oaklandpostonline.com/search/?t=article&l=15&c[]="

class SectionsViewController: BugFixTableViewController {
    let titles = ["News", "Life", "Sports", "Arts & Entertainment", "Opinion", "Satire"]
    let baseURLs = [
        "News": "\(prefix)news,news/*",
        "Life": "\(prefix)life,life/*",
        "Sports": "\(prefix)sports,sports/*",
        "Arts & Entertainment": "\(prefix)arts_and_entertainment,arts_and_entertainment/*",
        "Opinion": "\(prefix)opinion,opinion/*",
        "Satire": "\(prefix)satire,satire/*",
    ]

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == showSectionID {
            let postTableViewController = segue.destinationViewController as! PostTableViewController

            let section = (sender as! SectionsCell).titleLabel.text!
            postTableViewController.baseURL = baseURLs[section]
            postTableViewController.navigationItem.title = section
        }
    }

    // MARK: UITableViewDataSource

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(sectionsCellID, forIndexPath: indexPath) as! SectionsCell

        cell.titleLabel.text = titles[indexPath.row]

        return cell
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let ownHeight = view.bounds.height
        let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.height
        let navigationBarHeight = navigationController!.navigationBar.bounds.height
        let tabBarHeight = tabBarController!.tabBar.frame.height

        let availableHeight = ownHeight - statusBarHeight - navigationBarHeight - tabBarHeight

        return availableHeight / CGFloat(titles.count)
    }

    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        // Create an Array of each cells' index path.
        let indexPaths = (0..<titles.count).map { NSIndexPath(forRow: $0, inSection: 0) }

        tableView.beginUpdates()
        // Convince the table view to query the row heights again.
        tableView.reloadRowsAtIndexPaths(indexPaths, withRowAnimation: .Fade)
        tableView.endUpdates()
    }

}
