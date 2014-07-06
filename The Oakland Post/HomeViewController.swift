//
//  HomeViewController.swift
//  The Oakland Post
//
//  Created by Andrew Clissold on 6/13/14.
//  Copyright (c) 2014 Andrew Clissold. All rights reserved.
//

import UIKit

class HomeViewController: UITableViewController, MWFeedParserDelegate {

    let offsetAmount = 15

    var offset = 0
    var feedURL: NSURL {
    get {
        // http://goo.gl/jqzaQQ
        return NSURL(string: "http://www.oaklandpostonline.com/search/?mode=article&q=" +
            "&nsa=eedition&t=article&o=\(offset)&l=\(offsetAmount)&s=start_time&sd=desc&f=rss&d=" +
            "&d1=&d2=&c%5B%5D=news*%2Csports*%2Clife*%2Cbusiness*%2Copinion*%2Cspecial_sections*")
    }
    }
    var feedParser: MWFeedParser!

    var parsedItems = MWFeedItem[]()
    var dateFormatter: NSDateFormatter!
    var lastIndexPath: NSIndexPath?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Theme
        self.navigationController.navigationBar.barTintColor = oaklandPostBlue
        self.navigationController.navigationBar.barStyle = .Black

        // Pull to refresh
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = refreshControl

        dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .ShortStyle

        createParserAndParse()

        tableView.addInfiniteScrollingWithActionHandler(loadMorePosts)
    }

    func createParserAndParse() {
        feedParser = MWFeedParser(feedURL: feedURL)
        feedParser.delegate = self
        feedParser.feedParseType = ParseTypeFull
        feedParser.connectionType = ConnectionTypeAsynchronously
        feedParser.parse()
    }

    func refresh() {
        tableView.userInteractionEnabled = false
        offset = 0
        parsedItems.removeAll()
        feedParser.stopParsing()
        createParserAndParse()
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }

    func loadMorePosts() {
        tableView.userInteractionEnabled = false
        offset += offsetAmount
        createParserAndParse()
    }

    // MARK: MWFeedParserDelegate methods

    func feedParser(parser: MWFeedParser, didParseFeedItem item: MWFeedItem) {
        parsedItems.append(item)
    }

    func feedParserDidFinish(parser: MWFeedParser) {
        tableView.reloadData()
        refreshControl.endRefreshing()
        tableView.userInteractionEnabled = true
        tableView.infiniteScrollingView.stopAnimating()
    }

    // MARK: Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "readPost" {
            let indexPath = self.tableView.indexPathForSelectedRow()
            let item = parsedItems[indexPath.row] as MWFeedItem
            (segue.destinationViewController as PostViewController).url = item.link
        }
    }

    // MARK: Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parsedItems.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as TableViewCell

        let item = parsedItems[indexPath.row] as MWFeedItem

        // Set the cell's thumbnail image
        if item.enclosures != nil && item.enclosures[0] is NSDictionary {
            let enclosures = item.enclosures[0] as NSDictionary
            if enclosures["type"].containsString("image") {
                let URL = NSURL(string: enclosures["url"] as String)
                cell.thumbnail.setImageWithURL(URL, placeholderImage: UIImage(named: "Placeholder"))
            }
        }

        cell.descriptionLabel.text = item.title

        // Figure out and set the cell's date label
        var time = -item.date.timeIntervalSinceNow / 60.0
        var unit = "m"
        if time >= 60.0 {
            time /= 60.0
            unit = "h"
            if time >= 24.0 {
                time /= 24.0
                unit = "d"
            }
        }
        cell.dateLabel.text = "\(Int(time))\(unit) ago"

        return cell
    }

    override func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        return tableViewRowHeight;
    }

    // MARK: Bugfix for UITableViewCells getting stuck as selected

    override func viewWillAppear(animated: Bool)  {
        if lastIndexPath != nil {
            tableView.deselectRowAtIndexPath(lastIndexPath, animated: true)
        }
    }

    override func viewDidDisappear(animated: Bool)  {
        if lastIndexPath != nil {
            tableView.selectRowAtIndexPath(lastIndexPath, animated: false, scrollPosition: .None)
        }
    }

    override func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        lastIndexPath = indexPath
    }

}

