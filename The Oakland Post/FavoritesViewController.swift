//
//  FavoritesViewController.swift
//  The Oakland Post
//
//  Created by Andrew Clissold on 9/1/14.
//  Copyright (c) 2014 Andrew Clissold. All rights reserved.
//

class FavoritesViewController: UITableViewController {

    override func viewDidLoad() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log Out", style: .Bordered, target: self, action: "logOut")
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
