//
//  PhotosFeedParserDelegate.swift
//  The Oakland Post
//
//  Translates RSS to content for the Photos view.
//
//  Created by Andrew Clissold on 7/30/14.
//  Copyright (c) 2014 Andrew Clissold. All rights reserved.
//

class PhotosFeedParserDelegate: NSObject, MWFeedParserDelegate {

    var insertedIndexPaths = 0
    let cache = SDImageCache.sharedImageCache()
    let delegator: PhotosViewController

    init(delegator: PhotosViewController) {
        self.delegator = delegator
    }

    func feedParser(parser: MWFeedParser!, didParseFeedItem item: MWFeedItem!) {
        if !(item.enclosures != nil) { return }

        let enclosures = item.enclosures[0] as! NSDictionary
        let URLString = enclosures["url"] as! String

        if cache.diskImageExistsWithKey(URLString) {
            delegator.photos.append(cache.imageFromDiskCacheForKey(URLString))
        } else {
            let URL = NSURL(string: URLString)!
            let data = NSData(contentsOfURL: URL)!
            let image = UIImage(data: data)!
            cache.storeImage(image, forKey: URLString)
            delegator.photos.append(image)
        }

        delegator.URLs.append(item.link)
    }

    func feedParserDidFinish(parser: MWFeedParser!) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        SVProgressHUD.dismiss()
        delegator.finishedParsing = true

        var indexPaths = [NSIndexPath]()
        let start = insertedIndexPaths
        let end = delegator.photos.count
        for index in start..<end {
            indexPaths.append(NSIndexPath(forItem: index, inSection: 0))
        }

        delegator.collectionView!.performBatchUpdates({
                self.delegator.collectionView!.insertItemsAtIndexPaths(indexPaths)
            }, completion: { (completed: Bool) in
                if completed {
                    self.insertedIndexPaths += indexPaths.count
                }
                self.delegator.tabBarController!.tabBar.userInteractionEnabled = true
            })

        delegator.collectionView!.infiniteScrollingView.stopAnimating()
    }

    func feedParser(parser: MWFeedParser!, didFailWithError error: NSError!) {
        showAlertForErrorCode(feedParserDidFailErrorCode)
        delegator.finishedParsing = true
        delegator.collectionView!.infiniteScrollingView.stopAnimating()
        delegator.tabBarController!.tabBar.userInteractionEnabled = true
    }

}
