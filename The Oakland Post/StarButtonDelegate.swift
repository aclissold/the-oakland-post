//
//  StarButtonDelegate.swift
//  The Oakland Post
//
//  Created by Andrew Clissold on 9/3/14.
//  Copyright (c) 2014 Andrew Clissold. All rights reserved.
//

@objc protocol StarButtonDelegate {
    func didSelectStarButton(starButton: UIButton, atIndexPath indexPath: NSIndexPath)
}
