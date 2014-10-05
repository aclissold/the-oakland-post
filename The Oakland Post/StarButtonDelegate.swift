//
//  StarButtonDelegate.swift
//  The Oakland Post
//
//  Enables the conforming view controller to persist the feed item as a favorite.
//
//  Created by Andrew Clissold on 9/3/14.
//  Copyright (c) 2014 Andrew Clissold. All rights reserved.
//

@objc protocol StarButtonDelegate {
    func didSelectStarButton(starButton: UIButton, forItem item: MWFeedItem)
}
