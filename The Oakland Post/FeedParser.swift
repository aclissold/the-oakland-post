//
//  FeedParser.swift
//  The Oakland Post
//
//  Created by Andrew Clissold on 7/6/14.
//  Copyright (c) 2014 Andrew Clissold. All rights reserved.
//

import UIKit

// Wraps MWFeedParser with a default configuration and "parseMore" functionality.
class FeedParser {

    // readonly properties
    let length: Int
    var offset = 0

    // private properties
    var baseURL: String
    var delegate: MWFeedParserDelegate
    var parser: MWFeedParser!
    var feedURL: NSURL {
    get {
        return NSURL(string: "\(baseURL)&o=\(offset)&l=\(length)&f=rss")
    }
    }

    init(baseURL: String, length: Int, delegate: MWFeedParserDelegate) {
        self.baseURL = baseURL
        self.length = length
        self.delegate = delegate
    }

    func parseInitial() {
        offset = 0
        parse()
    }

    func parseMore() {
        offset += length
        parse()
    }

    // MARK: Private methods

    func parse() {
        createParser()
        parser.parse()
    }

    func createParser() {
        // parser will only be nil the first time parseInitial() is called
        if parser != nil && parser.parsing {
            parser.stopParsing()
        }

        parser = MWFeedParser(feedURL: feedURL)
        parser.delegate = delegate
        parser.feedParseType = ParseTypeFull
        parser.connectionType = ConnectionTypeAsynchronously
    }

}
