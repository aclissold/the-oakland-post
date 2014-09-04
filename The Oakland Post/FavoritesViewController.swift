//
//  FavoritesViewController.swift
//  The Oakland Post
//
//  Created by Andrew Clissold on 9/1/14.
//  Copyright (c) 2014 Andrew Clissold. All rights reserved.
//

class FavoritesViewController: UITableViewController, StarButtonDelegate {

    var objects: [AnyObject]!
    override func viewDidLoad() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log Out", style: .Bordered, target: self, action: "logOut")
        let query = PFQuery(className: "Item")
        query.limit = 1000
        query.findObjectsInBackgroundWithBlock { (objects, error) in
            if error != nil {
                showAlertForErrorCode(error.code)
            } else {
                self.objects = objects
                self.tableView.reloadData()
            }
        }
    }

    func logOut() {
        PFUser.logOut()
        configureLogOutButton()
        navigationController!.popViewControllerAnimated(true)
    }

    func configureLogOutButton() {
        var homeViewController: HomeViewController!
        for controller in navigationController!.viewControllers {
            if controller is HomeViewController { // probably viewControllers[0]
                let homeViewController = controller as HomeViewController
                homeViewController.navigationItem.rightBarButtonItem = homeViewController.logInBarButtonItem
                break
            }
        }
    }

    func didSelectStarButton(starButton: UIButton, withItem item: MWFeedItem, atIndexPath indexPath: NSIndexPath) {
        starButton.selected = !starButton.selected
        if starButton.selected {
            // Send the new favorite to Parse.
            PFObject(className: "Item", dictionary: [
                "identifier": item.identifier,
                     "title": item.title,
                      "link": item.link,
                      "date": item.date,
                   "summary": item.summary,
                    "author": item.author,
                "enclosures": item.enclosures]).saveEventually()
        } else {
            // Delete it from the server.
        }
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects?.count ?? 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath) as PostCell
        let item = MWFeedItem()
        let object = objects[indexPath.row] as PFObject

        item.identifier = object["identifier"] as String
        item.title = object["title"] as String
        item.link = object["link"] as String
        item.date = object["date"] as NSDate
        item.summary = object["summary"] as String
        item.author = object["author"] as String
        if object["enclosures"] != nil {
            item.enclosures = object["enclosures"] as NSArray
        }

        cell.delegate = self
        cell.indexPath = indexPath
        cell.item = item

        return cell

    }

    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let usernameLabel = UILabel()
        usernameLabel.text = PFUser.currentUser().username
        usernameLabel.textAlignment = .Center
        usernameLabel.textColor = oaklandPostBlue
        usernameLabel.font = UIFont(name: boldSansSerifName, size: 34)
        usernameLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        usernameLabel.sizeToFit()

        let view = UITableViewHeaderFooterView()
        view.contentView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        view.contentView.addSubview(usernameLabel)

        view.contentView.addConstraints([
            NSLayoutConstraint(
                item: usernameLabel,
                attribute: .CenterX,
                relatedBy: .Equal,
                toItem: view.contentView,
                attribute: .CenterX,
                multiplier: 1,
                constant: 0),
            NSLayoutConstraint(
                item: usernameLabel,
                attribute: .CenterY,
                relatedBy: .Equal,
                toItem: view.contentView,
                attribute: .CenterY,
                multiplier: 1,
                constant: 0)])

        return view
    }

    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }

}
