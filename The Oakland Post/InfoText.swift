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

// MARK: Text Styles

private func centeredParagraphStyle() -> NSMutableParagraphStyle {
    let style = NSMutableParagraphStyle()
    style.alignment = .Center
    return style
}

private func lineSpacingParagraphStyle() -> NSMutableParagraphStyle {
    let style = NSMutableParagraphStyle()
    style.lineSpacing = 1.5
    return style
}

private let heading = [
    NSFontAttributeName: UIFont(name: boldSansSerifName, size: CGFloat(24.0)),
    NSForegroundColorAttributeName: oaklandPostBlue,
    NSParagraphStyleAttributeName: centeredParagraphStyle()
]

private let subheading = [
    NSFontAttributeName: UIFont(name: boldSansSerifName, size: CGFloat(18.0))
]

private let text = [
    NSFontAttributeName: UIFont(name: serifName, size: CGFloat(16.0)),
    NSParagraphStyleAttributeName: lineSpacingParagraphStyle()
]

// MARK: Content

// An ordered array of (style, text) tuples.
typealias Component = (attributes: [NSObject: AnyObject], string: String)

private let space: Component = (text, "")

private func contentFromComponents(components: [Component]) -> NSAttributedString {
    var attributedString = NSMutableAttributedString()

    for component in components {
        let substring = NSMutableAttributedString(string: "\(component.string)\n\n", attributes: component.attributes)
        attributedString.appendAttributedString(substring)
    }

    return attributedString
}

private var aboutUs: NSAttributedString {
    let components: [Component] = [
        (text, "The Oakland Post is the student-run newspaper at Oakland " +
         "University in Rochester, Mich. Founded in 1973, The Post has provided " +
         "an independent source of news for students, faculty and alumni for " +
         "decades."),
        (text, "Released every Wednesday throughout the fall and winter " +
         "semesters (as well as monthly over the summer), The Post can be found " +
         "in nearly all buildings on campus and in several off-campus locations " +
         "in the surrounding area."),
        (text, "The Post is located in the basement of the Oakland Center next " +
         "to the radio station and the Student Congress office. Visitors can " +
         "park at metered spots in parking lot 2 or along Wilson Boulevard."),
        space,
        (subheading, "Mailing Address"),
        (text, "The Oakland Post\n61 Oakland Center\nRochester, MI 48306"),
        space,
        (subheading, "Letter Policy"),
        (text, "Writers must provide full name, class rank or " +
         "university/community affiliation, phone number and field of study (if " +
         "applicable). Please limit letters to 250 words or less. Letters may be " +
         "edited for content, length and grammar."),
        space,
        (subheading, "Comment Policy"),
        (text, "The Oakland Post welcomes comments from readers of the " +
         "oaklandpostonline.com, but we want the site to be a place where people " +
         "can debate issues vigorously and remain respectful. In that respect, " +
         "we ask that commenters refrain from personal attacks and profanity or " +
         "language offensive to ordinary sensibility. Just like our Letter " +
         "Policy, we ask that you use your full name and email (OU address if " +
         "you’re a student) when commenting. Comments close after 14 days of " +
         "publication."),
        space,
        (heading, "Network with The Oakland Post"),
        (text, "facebook.com/theoakpost\n" +
         "twitter.com/theoaklandpost\n" +
         "youtube.com/theoaklandpostonline\n" +
         "flickr.com/photos/theoaklandpost\n" +
         "instagram.com/theoaklandpost"),
        space,
        (heading, "Employment"),
        (text, "Submit résumé, clips and cover letter to " +
         "editor@oaklandpostonline.com and managing@oaklandpostonline.com.")
     ]

    return contentFromComponents(components)
}

private let contactUs = NSAttributedString(string: "Contact Us")
private let staff = NSAttributedString(string: "Staff")
