//
//  BugFixTableViewController.swift
//  The Oakland Post
//
//  Provides a fix for UITableViewCells flickering and getting stuck as selected
//  when the swipe-from-left gesture to go back is performed in a certain manner.
//
//  Subclasses overriding these methods must remember to call super for it to work properly.
//
//  Created by Andrew Clissold on 7/12/14.
//  Copyright (c) 2014 Andrew Clissold. All rights reserved.
//

import UIKit

class BugFixTableViewController: UITableViewController {

    // private
    var lastIndexPath: NSIndexPath?

    override func viewWillAppear(animated: Bool)  {
        if lastIndexPath != nil {
            tableView.deselectRowAtIndexPath(lastIndexPath, animated: true)
        }
    }

    override func viewDidDisappear(animated: Bool)  {
        if lastIndexPath != nil {
            tableView.selectRowAtIndexPath(lastIndexPath, animated: false, scrollPosition: .None)
        }
    }

    override func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        lastIndexPath = indexPath
    }

}
