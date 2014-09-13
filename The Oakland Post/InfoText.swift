//
//  InfoText.swift
//  The Oakland Post
//
//  Created by Andrew Clissold on 9/12/14.
//  Copyright (c) 2014 Andrew Clissold. All rights reserved.
//

var infoTexts: [String: NSAttributedString] = [
      "About Us": aboutUs,
    "Contact Us": contactUs,
         "Staff": staff
]

private let contactUs = NSAttributedString(string: "Contact Us")
private let staff = NSAttributedString(string: "Staff")

private func centeredParagraphStyle() -> NSMutableParagraphStyle {
    let style = NSMutableParagraphStyle()
    style.alignment = .Center
    return style
}

private let heading = [
    NSFontAttributeName: UIFont(name: boldSansSerifName, size: CGFloat(24.0)),
    NSForegroundColorAttributeName: oaklandPostBlue,
    NSParagraphStyleAttributeName: centeredParagraphStyle()
]

private let subheading = [
    NSFontAttributeName: UIFont(name: boldSansSerifName, size: CGFloat(20.0)),
    NSForegroundColorAttributeName: oaklandPostBlue,
]

private let text = [
    NSFontAttributeName: UIFont(name: serifName, size: CGFloat(16.0))
]

// MARK: Generating Text

// An ordered array of (style, text) tuples.
typealias Components = [(attributes: [NSObject: AnyObject], string: String)]

private var aboutUs: NSAttributedString {
    let components: Components = [
        (heading, "Heading Text"),
        (text, "A normal paragraph of text. Let's see if this works.")
    ]

    return contentFromComponents(components)
}

private func contentFromComponents(components: Components) -> NSAttributedString {
    var attributedString = NSMutableAttributedString()

    for component in components {
        let substring = NSMutableAttributedString(string: "\(component.string)\n\n", attributes: component.attributes)
        attributedString.appendAttributedString(substring)
    }

    return attributedString
}
