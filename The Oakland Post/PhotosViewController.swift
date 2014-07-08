//
//  PhotosViewController.swift
//  The Oakland Post
//
//  Created by Andrew Clissold on 7/5/14.
//  Copyright (c) 2014 Andrew Clissold. All rights reserved.
//

import UIKit

class PhotosViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout,
    NHBalancedFlowLayoutDelegate, UICollectionViewDataSource, MWFeedParserDelegate {

    let baseURL = "http://www.oaklandpostonline.com/search/?t=image&sd=desc&f=rss"
    let cache = SDImageCache.sharedImageCache()

    var photos: [UIImage] = []
    var feedParser: FeedParser!

    override func viewDidLoad() {
        // Theme
        self.navigationController.navigationBar.barTintColor = oaklandPostBlue
        self.navigationController.navigationBar.barStyle = .Black

        feedParser = FeedParser(baseURL: baseURL, length: 15, delegate: self)
        feedParser.parseInitial()

        collectionView.addInfiniteScrollingWithActionHandler(feedParser.parseMore)
    }

    // MARK: MWFeedParserDelegate methods

    func feedParser(parser: MWFeedParser!, didParseFeedItem item: MWFeedItem!) {
        let enclosures = item.enclosures[0] as NSDictionary
        let URLString = enclosures["url"] as String

        if cache.diskImageExistsWithKey(URLString) {
            photos.append(cache.imageFromDiskCacheForKey(URLString))
        } else {
            let URL = NSURL(string: URLString)
            let data = NSData(contentsOfURL: URL)
            let image = UIImage(data: data)
            cache.storeImage(image, forKey: URLString)
            photos.append(image)
        }

    }

    func feedParserDidFinish(parser: MWFeedParser!) {
        var indexPaths = [NSIndexPath]()
        let start = feedParser.offset
        let end = start + feedParser.length
        for index in start..<end {
            indexPaths.append(NSIndexPath(forItem: index, inSection: 0))
        }
        collectionView.performBatchUpdates({
                self.collectionView.insertItemsAtIndexPaths(indexPaths)
            }, completion: nil)
        collectionView.infiniteScrollingView.stopAnimating()
    }

    // MARK: NHBalancedFlowLayoutDelegate

    func collectionView(collectionView: UICollectionView!,
        layout collectionViewLayout: NHBalancedFlowLayout!,
        preferredSizeForItemAtIndexPath indexPath: NSIndexPath!) -> CGSize {
            return photos[indexPath.item].size
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView!) -> Int {
        return 1
    }

    override func collectionView(collectionView: UICollectionView!,
        numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }

    override func collectionView(collectionView: UICollectionView!,
        cellForItemAtIndexPath indexPath: NSIndexPath!) -> UICollectionViewCell! {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(photoCellID,
                forIndexPath: indexPath) as PhotoCell
            cell.imageView.image = photos[indexPath.item]
            return cell
    }

}
