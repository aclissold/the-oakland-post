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

private let extraSpace: Component = (text, "")

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

        extraSpace,

        (subheading, "Mailing Address"),
        (text, "The Oakland Post\n61 Oakland Center\nRochester, MI 48306"),

        extraSpace,

        (subheading, "Letter Policy"),
        (text, "Writers must provide full name, class rank or " +
         "university/community affiliation, phone number and field of study (if " +
         "applicable). Please limit letters to 250 words or less. Letters may be " +
         "edited for content, length and grammar."),

        extraSpace,

        (subheading, "Comment Policy"),
        (text, "The Oakland Post welcomes comments from readers of the " +
         "oaklandpostonline.com, but we want the site to be a place where people " +
         "can debate issues vigorously and remain respectful. In that respect, " +
         "we ask that commenters refrain from personal attacks and profanity or " +
         "language offensive to ordinary sensibility. Just like our Letter " +
         "Policy, we ask that you use your full name and email (OU address if " +
         "you’re a student) when commenting. Comments close after 14 days of " +
         "publication."),

        extraSpace,

        (heading, "Network with\nThe Oakland Post"),
        (text, "facebook.com/theoakpost\n" +
         "twitter.com/theoaklandpost\n" +
         "youtube.com/theoaklandpostonline\n" +
         "flickr.com/photos/theoaklandpost\n" +
         "instagram.com/theoaklandpost"),

        extraSpace,

        (heading, "Employment"),
        (text, "Submit résumé, clips and cover letter to " +
         "editor@oaklandpostonline.com and managing@oaklandpostonline.com.")
     ]

    return contentFromComponents(components)
}

private var contactUs: NSAttributedString {
    let components: [Component] = [
        (subheading, "Address"),
        (text, "The Oakland Post\n61 Oakland Center\nRochester, MI 48306"),

        (subheading, "Email"),
        (text, "editor@oaklandpostonline.com\nmanaging@oaklandpostonline.com"),

        (subheading, "Phone"),
        (text, "(248) 370-4268\n(248) 370-2537")
     ]

    return contentFromComponents(components)
}

private var staff: NSAttributedString {
    let components: [Component] = [
        (subheading, "Editor-in-Chief"),
        (text, "Oona Goodin-Smith\n" +
         "(248) 370-4268\n" +
         "editor@oaklandpostonline.com"),

        (subheading, "Managing Editor"),
        (text, "Kaylee Kean\n" +
         "(248) 370-2537\n" +
         "managing@oaklandpostonline.com"),

        (subheading, "Web Editor"),
        (text, "Jake Alsko\n" +
         "web@oaklandpostonline.com"),

        (subheading, "Life, Arts & Entertainment Editor"),
        (text, "Andrew Wernette\n" +
         "life@oaklandpostonline.com"),

        (subheading, "Campus & Administration Editor"),
        (text, "Ali DeRees\n" +
         "campus@oaklandpostonline.com"),

        (subheading, "Sports Editor"),
        (text, "Jackson Gilbert\n" +
         "sports@oaklandpostonline.com"),

        (subheading, "Photo Editor"),
        (text, "Salwan Georges\n" +
         "photos@oaklandpostonline.com"),

        (subheading, "Chief Copy Editor"),
        (text, "Haley Kotwicki"),

        (subheading, "Copy Editors"),
        (text, "Josh Soltman"),

        (subheading, "Graphic Design"),
        (text, "Kelly Lara\n" +
         "Benjamin DerMiner"),

        (subheading, "Photographers"),
        (text, "Michael Ferdinande\n" +
         "Danielle Cojocari\n" +
         "Katherine Snoad\n" +
         "Shannon Wilson"),

        (subheading, "Staff Reporters"),
        (text, "Matt Saulino\n" +
         "Sam Schlenner\n" +
         "Sean Miller\n" +
         "Joseph Bach\n" +
         "Kaseb Ahmad\n" +
         "Scott Davis\n" +
         "Jessie DiBattista"),

        (subheading, "Staff Interns/Bloggers"),
        (text, "Michael Pulis\n" +
         "Johnny Oldani\n" +
         "Bobby Boutin"),

        (subheading, "Distribution"),
        (text, "Andrew Greer - Distribution Director\n" +
         "Brian Murray - Distribution Manager\n" +
         "Ted Tansley\n" +
         "Jacob Chessrown"),

        (subheading, "Advertising"),
        (text, "ads@oaklandpostonline.com\n" +
         "(248) 370-4269"),

        (subheading, "Advisers"),
        (text, "Holly Gilbert\n" +
         "(248) 370-4138\n" +
         "shreve@oakland.edu\n" +
         "\n" +
         "Don Ritenburgh\n" +
         "(248) 370-2533\n" +
         "ritenbur@oakland.edu")
     ]

    return contentFromComponents(components)
}
