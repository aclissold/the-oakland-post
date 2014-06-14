//
//  TableViewCell.swift
//  The Oakland Post
//
//  Created by Andrew Clissold on 6/14/14.
//  Copyright (c) 2014 Andrew Clissold. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet var thumbnail : UIImageView
    @IBOutlet var descriptionLabel: UILabel

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
