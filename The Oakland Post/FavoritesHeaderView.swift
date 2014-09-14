//
//  FavoritesHeaderView.swift
//  The Oakland Post
//
//  Created by Andrew Clissold on 9/13/14.
//  Copyright (c) 2014 Andrew Clissold. All rights reserved.
//

class FavoritesHeaderView: UITableViewHeaderFooterView {
    required init(coder aDecoder: NSCoder) { fatalError("wrong initializer") }

    override init(frame: CGRect) {
        super.init(frame: frame)

        let usernameLabel = UILabel()
        usernameLabel.text = PFUser.currentUser().username
        usernameLabel.textAlignment = .Center
        usernameLabel.textColor = oaklandPostBlue
        usernameLabel.font = UIFont(name: boldSansSerifName, size: 34)
        usernameLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        usernameLabel.sizeToFit()

        contentView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        contentView.addSubview(usernameLabel)

        contentView.addConstraints([
            NSLayoutConstraint(
                item: usernameLabel,
                attribute: .CenterX,
                relatedBy: .Equal,
                toItem: contentView,
                attribute: .CenterX,
                multiplier: 1,
                constant: 0),
            NSLayoutConstraint(
                item: usernameLabel,
                attribute: .CenterY,
                relatedBy: .Equal,
                toItem: contentView,
                attribute: .CenterY,
                multiplier: 1,
                constant: 0)])
    }
}
