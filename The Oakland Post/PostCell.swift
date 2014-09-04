//
//  PostCell.swift
//  The Oakland Post
//
//  Created by Andrew Clissold on 6/14/14.
//  Copyright (c) 2014 Andrew Clissold. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {

    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var starButton: UIButton!

    weak var delegate: StarButtonDelegate?
    var indexPath: NSIndexPath!

    @IBAction func starButtonPressed(sender: UIButton) {
        delegate?.didSelectStarButton(sender, atIndexPath: indexPath)
    }

    override func prepareForReuse() {
        starButton.selected = false
        super.prepareForReuse()
    }

}
