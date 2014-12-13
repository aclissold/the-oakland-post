//
//  FeedParser.swift
//  The Oakland Post
//
//  Wraps MWFeedParser with a default configuration and "parseMore" functionality.
//
//  Created by Andrew Clissold on 7/6/14.
//  Copyright (c) 2014 Andrew Clissold. All rights reserved.
//

import UIKit

class FeedParser {

    let length: Int
    var offset = 0

    private var baseURL: String
    private var delegate: MWFeedParserDelegate
    private var parser: MWFeedParser!
    private var feedURL: NSURL {
        get {
            return NSURL(string: "\(baseURL)&o=\(offset)&l=\(length)&f=rss")!
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

    private func parse() {
        createParser()
        parser.parse()
    }

    private func createParser() {
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
