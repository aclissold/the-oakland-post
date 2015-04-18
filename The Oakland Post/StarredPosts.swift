//
//  StarredPosts.swift
//  The Oakland Post
//
//  Global arrays of starred Posts and their identifiers, as well as helper functions for them.
//
//  Created by Andrew Clissold on 9/12/14.
//  Copyright (c) 2014 Andrew Clissold. All rights reserved.
//

private(set) var starredPostIdentifiers: [String] = [String]()

class BugFixWrapper { // vars defined globally segfault the compiler in Xcode 6.3 Beta 1
    static var starredPosts: [AnyObject] = [AnyObject]() {
        didSet {
            // Compute starredPostIdentifiers.
            starredPostIdentifiers = [String]()
            for object in starredPosts {
                let ident = object["identifier"] as! String
                starredPostIdentifiers.append(ident)
            }

            // Sort self.
            starredPosts.sort {
                let first = ($0 as! PFObject)["date"] as! NSDate
                let second = ($1 as! PFObject)["date"] as! NSDate
                return first.compare(second) == NSComparisonResult.OrderedDescending
            }
        }
    }
}

func deleteStarredPostWithIdentifier(identifier: String) {
    removeFromArray(identifier)
    onMain {
        // Fetch the starred post from Parse and delete it.
        let query = PFQuery(className: "Item")
        query.whereKey("identifier", equalTo: identifier)
        query.findObjectsInBackgroundWithBlock { (objects, error) in
            if error != nil {
                showAlertForErrorCode(error!.code)
                return
            }

            objects!.first?.deleteEventually()
        }
    }
}

private func removeFromArray(identifier: String) {
    for (index, object) in enumerate(BugFixWrapper.starredPosts as! [PFObject]) {
        if object["identifier"] as! String == identifier {
            BugFixWrapper.starredPosts.removeAtIndex(index)
            break
        }
    }
}
