//
//  StarredPosts.swift
//  The Oakland Post
//
//  Created by Andrew Clissold on 9/12/14.
//  Copyright (c) 2014 Andrew Clissold. All rights reserved.
//

var starredPostIdentifiers: [String] = [String]()

var starredPosts: [AnyObject] = [AnyObject]() {
didSet {
    starredPostIdentifiers = [String]()
    for object in starredPosts {
        let ident = object["identifier"] as String
        starredPostIdentifiers.append(ident)
    }
    starredPosts.sort {
        let first = ($0 as PFObject)["date"] as NSDate
        let second = ($1 as PFObject)["date"] as NSDate
        return first.compare(second) == NSComparisonResult.OrderedDescending
    }
}
}

func deleteStarredPostWithIdentifier(identifier: String) {
    removeFromArray(identifier)
    onMain {
        let query = PFQuery(className: "Item")
        query.whereKey("identifier", equalTo: identifier)
        query.findObjectsInBackgroundWithBlock { (objects, error) in
            if error != nil {
                showAlertForErrorCode(error.code)
                return
            }

            objects.first?.deleteEventually()
        }
    }
}

private func removeFromArray(identifier: String) {
    for (index, object) in enumerate(starredPosts as [PFObject]) {
        if object["identifier"] as String == identifier {
            starredPosts.removeAtIndex(index)
            break
        }
    }
}
