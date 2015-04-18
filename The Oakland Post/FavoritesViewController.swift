//
//  FavoritesViewController.swift
//  The Oakland Post
//
//  A table view of starred posts for logged-in users, as well as profile information and a log out button.
//
//  Created by Andrew Clissold on 9/1/14.
//  Copyright (c) 2014 Andrew Clissold. All rights reserved.
//

class FavoritesViewController: BugFixTableViewController, StarButtonDelegate {

    private var didEnableButtonForPushers = false

    override func viewDidLoad() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log Out", style: .Bordered, target: self, action: "logOut")
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(tableView, selector: "reloadData",
            name: foundStarredPostsNotification, object: nil)
    }

    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(tableView)
    }

    func logOut() {
        PFUser.logOut()
        configureLogOutButton()
        BugFixWrapper.starredPosts.removeAll(keepCapacity: false)
        navigationController!.popViewControllerAnimated(true)
    }

    func configureLogOutButton() {
        homeViewController.navigationItem.rightBarButtonItem = homeViewController.logInBarButtonItem
        homeViewController.tableView.reloadData()
    }

    private var firstCheck = false
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        if !firstCheck {
            firstCheck = true

            // Avoid redundant API requests by checking PFUser first.
            let canPush = PFUser.currentUser()?["canPush"] as? Bool
            if canPush != nil && canPush! {
                enableButtonForPushers()
            }
        }
    }

    func enableButtonForPushers() {
        // Not a security feature--just meant to keep otherwise dead UI disabled.
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        self.tableView.cellForRowAtIndexPath(indexPath)!.userInteractionEnabled = false
        let roleQuery = PFRole.query()!
        roleQuery.whereKey("name", equalTo: "pusher")

        roleQuery.getFirstObjectInBackgroundWithBlock { (object, error) in
            if object == nil { return }
            let role = object as! PFRole
            let userQuery = role.users.query()!

            userQuery.findObjectsInBackgroundWithBlock({ (objects, error) in
                if objects == nil { return }
                for user in objects as! [PFUser] {
                    if PFUser.currentUser() == nil { return }
                    if user.username == PFUser.currentUser()!.username {
                        self.didEnableButtonForPushers = true
                        self.tableView.reloadData()
                    }
                }
            })
        }
    }

    // MARK: StarButtonDelegate

    func didSelectStarButton(starButton: UIButton, forItem item: MWFeedItem) {
        starButton.selected = !starButton.selected
        if starButton.selected {
            // Send the new favorite to Parse.
            let object = PFObject(item: item)
            object.saveEventually()
            BugFixWrapper.starredPosts.append(object)
        } else {
            deleteStarredPostWithIdentifier(item.identifier)
            deleteTableViewRowWithItem(item)
            homeViewController.reloadData()
        }
    }

    func deleteTableViewRowWithItem(item: MWFeedItem) {
        var indexPath: NSIndexPath!
        loop: for cell in tableView.visibleCells() {
            if let postCell = cell as? PostCell {
                if postCell.item.identifier == item.identifier {
                    indexPath = tableView.indexPathForCell(cell as! UITableViewCell)!
                    break loop
                }
            }
        }

        tableView.beginUpdates()
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        tableView.endUpdates()
    }

    // UITableView

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return BugFixWrapper.starredPosts.count + 1
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return indexPath.row == 0 ? tableViewHeaderHeight : tableViewRowHeight
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        super.tableView(tableView, didSelectRowAtIndexPath: indexPath)
        let cell = tableView.cellForRowAtIndexPath(indexPath)!
        if indexPath.row == 0 && !cell.userInteractionEnabled {
            tableView.deselectRowAtIndexPath(indexPath, animated: false)
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier(favoritesHeaderViewID, forIndexPath: indexPath) as! FavoritesHeaderView
            cell.usernameLabel.text = PFUser.currentUser()!.username
            cell.userInteractionEnabled = didEnableButtonForPushers
            return cell
        }

        let cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath) as! PostCell
        let object = BugFixWrapper.starredPosts[indexPath.row - 1] as! PFObject
        let item = MWFeedItem(object: object)

        cell.delegate = self
        cell.item = item
        cell.starButton.selected = true

        return cell
    }

    // MARK: Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == readPostID {
            let link = (sender as! PostCell).item.link
            (segue.destinationViewController as! PostViewController).URL = link
        }
    }

}
