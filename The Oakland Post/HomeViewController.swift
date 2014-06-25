//
//  HomeViewController.swift
//  The Oakland Post
//
//  Created by Andrew Clissold on 6/13/14.
//  Copyright (c) 2014 Andrew Clissold. All rights reserved.
//

import UIKit

class HomeViewController: UITableViewController, MWFeedParserDelegate {

    // http://www.oaklandpostonline.com/search/?mode=article&q=&nsa=eedition&t=article&l=15&s=start_time&sd=desc&f=rss&d=&d1=&d2=&c%5B%5D=news*%2Csports*%2Clife*%2Cbusiness*%2Copinion*%2Cspecial_sections
    let feedURL = NSURL(string: "http://www.oaklandpostonline.com/search/" +
        "?mode=article&q=&nsa=eedition&t=article&l=15&s=start_time&sd=desc&f=rss&d=&d1=&d2=" +
        "&c%5B%5D=news*%2Csports*%2Clife*%2Cbusiness*%2Copinion*%2Cspecial_sections*")
    var feedParser: MWFeedParser? = nil

    var parsedItems = Array<MWFeedItem>()
    var dateFormatter = NSDateFormatter()
    var lastIndexPath: NSIndexPath? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        // Theme
        self.navigationController.navigationBar.barTintColor = oaklandPostBlue
        self.navigationController.navigationBar.barStyle = .Black

        // Pull to refresh
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = refreshControl

        self.dateFormatter.dateStyle = .ShortStyle

        setUpParser()
    }

    func setUpParser() {
        feedParser = MWFeedParser(feedURL: feedURL)
        feedParser!.delegate = self
        feedParser!.feedParseType = ParseTypeFull
        feedParser!.connectionType = ConnectionTypeAsynchronously
        feedParser!.parse()
    }

    func refresh() {
        tableView.userInteractionEnabled = false
        parsedItems.removeAll()
        feedParser!.stopParsing()
        feedParser!.parse()
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }

    // MARK: MWFeedParserDelegate methods

    func feedParser(parser: MWFeedParser, didParseFeedItem item: MWFeedItem) {
        parsedItems.append(item)
    }

    func feedParserDidFinish(parser: MWFeedParser) {
        parsedItems = sort(parsedItems) { $0.date.timeIntervalSinceDate($1.date) > 0 }
        tableView.reloadData()
        refreshControl.endRefreshing()
        tableView.userInteractionEnabled = true
    }

    // MARK: Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            let indexPath = self.tableView.indexPathForSelectedRow()
            let item = parsedItems[indexPath.row] as MWFeedItem
            (segue.destinationViewController as DetailViewController).detailItem = item
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

