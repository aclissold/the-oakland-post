//
//  PhotosViewController.swift
//  The Oakland Post
//
//  Created by Andrew Clissold on 7/5/14.
//  Copyright (c) 2014 Andrew Clissold. All rights reserved.
//

import UIKit

class PhotosViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout,
    NHBalancedFlowLayoutDelegate, UICollectionViewDataSource, MWFeedParserDelegate, TopScrollable {

    let baseURL = "http://www.oaklandpostonline.com/search/?t=article&sd=desc&f=rss"
    let cache = SDImageCache.sharedImageCache()

    var photos = [UIImage]()
    var URLs = [String]()
    var enlargedPhoto: EnlargedPhoto?

    var feedParser: FeedParser!
    var finishedParsing = false

    var canScrollToTop = false

    // MARK: Lifecycle

    override func viewDidLoad() {
        feedParser = FeedParser(baseURL: baseURL, length: 15, delegate: self)
        feedParser.parseInitial()

        collectionView.addInfiniteScrollingWithActionHandler(parseMore)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        canScrollToTop = true
        if !finishedParsing {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            SVProgressHUD.show()
        }
    }

    override func viewDidDisappear(animated: Bool) {
        canScrollToTop = false
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        SVProgressHUD.dismiss()
    }

    override func viewWillLayoutSubviews() {
        let window = UIApplication.sharedApplication().windows[0] as UIWindow
        if let photo = enlargedPhoto {
            photo.frame = window.frame
        }
    }

    // MARK: Miscellaneous

    func parseMore() {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        feedParser.parseMore()
    }

    func scrollToTop() {
        let rect = CGRect(origin: CGPointZero, size: CGSize(width: 1, height: 1))
        collectionView.scrollRectToVisible(rect, animated: true)
    }

    // MARK: Enlarged Photo Handling

    var shouldHideStatusBar = false
    let enlargedPhotoDelegate = EnlargedPhotoDelegate()
    let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.height
    override func prefersStatusBarHidden() -> Bool {
        return shouldHideStatusBar
    }

    @IBAction func addEnlargedPhoto(sender: UIButton) {
        if enlargedPhoto { return } // the user probably tapped two at once

        enlargedPhoto = EnlargedPhoto(image: photos[sender.tag], highResImageURL: URLs[sender.tag])
        enlargedPhotoDelegate.zoomView = enlargedPhoto!.imageView
        enlargedPhoto!.scrollView.delegate = enlargedPhotoDelegate

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "removeEnlargedPhoto")
        enlargedPhoto!.addGestureRecognizer(tapGestureRecognizer)

        let window = UIApplication.sharedApplication().windows[0] as UIWindow
        window.addSubview(enlargedPhoto)

        shouldHideStatusBar = true
        setNeedsStatusBarAppearanceUpdate()
        navigationController.navigationBar.frame.size.height += statusBarHeight

        UIView.animateWithDuration(0.15) {
            self.enlargedPhoto!.alpha = 1
        }
    }

    func removeEnlargedPhoto() {
        shouldHideStatusBar = false
        setNeedsStatusBarAppearanceUpdate()
        UIView.animateWithDuration(0.15,
            animations: { self.enlargedPhoto!.alpha = 0 },
            completion: { _ in
                self.enlargedPhoto!.removeFromSuperview()
                self.enlargedPhoto = nil
            }
        )
    }

    // MARK: MWFeedParserDelegate methods

    func feedParser(parser: MWFeedParser!, didParseFeedItem item: MWFeedItem!) {
        if !item.enclosures { return }

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

        URLs.append(item.link)
    }

    var insertedIndexPaths = 0
    func feedParserDidFinish(parser: MWFeedParser!) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        SVProgressHUD.dismiss()
        finishedParsing = true

        var indexPaths = [NSIndexPath]()
        let start = insertedIndexPaths
        let end = photos.count
        for index in start..<end {
            indexPaths.append(NSIndexPath(forItem: index, inSection: 0))
        }

        collectionView.performBatchUpdates({
                self.collectionView.insertItemsAtIndexPaths(indexPaths)
            }, completion: { (completed: Bool) in
                if completed {
                    self.insertedIndexPaths += indexPaths.count
                } else {
                    fatalError("failed to insert items")
                }
            })

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
            cell.imageButton.setBackgroundImage(photos[indexPath.item], forState: .Normal)
            cell.imageButton.tag = indexPath.item
            return cell
    }

}
