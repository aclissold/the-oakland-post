//
//  ToolbarTitleText.swift
//  The Oakland Post
//
//  Themes a plain String for InfoContentViewController instances' title bars.
//
//  Created by Andrew Clissold on 8/2/14.
//  Copyright (c) 2014 Andrew Clissold. All rights reserved.
//

func toolbarTitleText(string: String) -> NSAttributedString {
    return NSAttributedString(string: string,
        attributes: [
            NSFontAttributeName: UIFont(name: boldSansSerifName, size: 25)!,
            NSForegroundColorAttributeName: oaklandPostBlue
        ])
}
