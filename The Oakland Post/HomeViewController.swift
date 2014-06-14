//
//  HomeViewController.swift
//  The Oakland Post
//
//  Created by Andrew Clissold on 6/13/14.
//  Copyright (c) 2014 Andrew Clissold. All rights reserved.
//

import UIKit

class HomeViewController: UITableViewController, MWFeedParserDelegate {

    let feedURL = NSURL(string: "http://www.oaklandpostonline.com/search/" +
        "?mode=article&q=&nsa=eedition&t=article&l=15&s=start_time&sd=desc&f=rss&d=&d1=&d2=" +
        "&c%5B%5D=news*%2Csports*%2Clife*%2Cbusiness*%2Copinion*%2Cspecial_sections*")

    var objects = NSMutableArray()
    var parsedItems = Array<MWFeedItem>()
    var dateFormatter = NSDateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Theme
        self.navigationController.navigationBar.barTintColor = oaklandPostBlue
        self.navigationController.navigationBar.barStyle = .Black

        self.dateFormatter.dateStyle = .ShortStyle

        downloadFeed()
    }

    func downloadFeed() {
        var feedParser = MWFeedParser(feedURL: feedURL)
        feedParser.delegate = self
        feedParser.feedParseType = ParseTypeFull
        feedParser.connectionType = ConnectionTypeAsynchronously
        feedParser.parse()
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }

    // MARK: MWFeedParserDelegate methods

    func feedParser(parser: MWFeedParser, didParseFeedItem item: MWFeedItem) {
        parsedItems.append(item)
    }

    func feedParserDidFinish(parser: MWFeedParser) {
        let sortedItems = sort(parsedItems) { $0.date.timeIntervalSinceDate($1.date) > 0 }
        for item in sortedItems {
            let date = dateFormatter.stringFromDate(item.date)
            let title = item.title
            println("\(date): \(title)")
        }
    }

    // MARK: Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            let indexPath = self.tableView.indexPathForSelectedRow()
            let object = objects[indexPath.row] as NSDate
            (segue.destinationViewController as DetailViewController).detailItem = object
        }
    }

    // MARK: Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell

        let object = objects[indexPath.row] as NSDate
        cell.textLabel.text = object.description
        return cell
    }

}

