//
//  TopScrollable.swift
//  The Oakland Post
//
//  Usage:
//
//      if topScrollable.canScrollToTop {
//          topScrollable.scrollToTop()
//      }
//
//  where implementation details are left to the conforming class.
//
//  Created by Andrew Clissold on 7/23/14.
//  Copyright (c) 2014 Andrew Clissold. All rights reserved.
//

@objc protocol TopScrollable {
    func scrollToTop()
    var canScrollToTop: Bool { get }
}
