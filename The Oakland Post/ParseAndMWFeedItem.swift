//
//  ParseAndMWFeedItem.swift
//  The Oakland Post
//
//  Extensions bridging Parse and MWFeedItem.
//
//  Created by Andrew Clissold on 9/13/14.
//  Copyright (c) 2014 Andrew Clissold. All rights reserved.
//

extension PFObject {
    convenience init(item: MWFeedItem) {
        self.init(className: "Item", dictionary: [
            "identifier": item.identifier,
            "title": item.title,
            "link": item.link,
            "date": item.date,
            "summary": item.summary])
        if item.author != nil {
            self["author"] = item.author
        }
        if item.enclosures != nil {
            self["enclosures"] = item.enclosures
        }
    }
}

extension MWFeedItem {
    convenience init(object: PFObject) {
        self.init()
        identifier = object["identifier"] as! String
        title = object["title"] as! String
        link = object["link"] as! String
        date = object["date"] as! NSDate
        summary = object["summary"] as! String
        if object["author"] != nil {
            author = object["author"] as! String
        }
        if object["enclosures"] != nil {
            enclosures = object["enclosures"] as! [AnyObject]
        }
    }
}
