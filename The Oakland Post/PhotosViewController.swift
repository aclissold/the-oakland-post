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
    var highResPhotos = [Int: UIImage]()
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

    func receivePhoto(photo: UIImage, forIndex index: Int) {
        highResPhotos[index] = photo
    }

    @IBAction func addEnlargedPhoto(sender: UIButton) {
        if enlargedPhoto { return } // the user probably tapped two at once

        let index = sender.tag

        if let highResPhoto = highResPhotos[index] {
            enlargedPhoto = EnlargedPhoto(image: highResPhoto, index: index)
        } else {
            enlargedPhoto = EnlargedPhoto(image: photos[index], index: index)
            HighResImageDownloader.downloadFromURL(URLs[index],
                forEnlargedPhoto: enlargedPhoto!, sender: sender, finished: self.receivePhoto)
        }
        enlargedPhotoDelegate.zoomView = enlargedPhoto!.imageView
        enlargedPhoto!.scrollView.delegate = enlargedPhotoDelegate

        addGestureRecognizersToEnlargedPhoto(enlargedPhoto!)

        let window = UIApplication.sharedApplication().windows[0] as UIWindow
        window.addSubview(enlargedPhoto)

        shouldHideStatusBar = true
        setNeedsStatusBarAppearanceUpdate()
        navigationController.navigationBar.frame.size.height += statusBarHeight

        UIView.animateWithDuration(0.15) {
            self.enlargedPhoto!.alpha = 1
        }
    }

    func addGestureRecognizersToEnlargedPhoto(enlargedPhoto: EnlargedPhoto) {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "singleTapReceived")
        let doubleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: "doubleTapReceived")
        let swipeUpGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "swipeUpReceived")

        swipeUpGestureRecognizer.direction = .Up
        doubleTapGestureRecognizer.numberOfTapsRequired = 2
        tapGestureRecognizer.requireGestureRecognizerToFail(doubleTapGestureRecognizer)

        enlargedPhoto.addGestureRecognizer(tapGestureRecognizer)
        enlargedPhoto.addGestureRecognizer(doubleTapGestureRecognizer)
        enlargedPhoto.addGestureRecognizer(swipeUpGestureRecognizer)
    }


    func singleTapReceived() {
        removeEnlargedPhoto()
    }

    func doubleTapReceived() {
        // TODO: zoom enlargedPhoto.scrollView
    }

    func swipeUpReceived() {
        removeEnlargedPhoto()
    }

    func removeEnlargedPhoto() {
        let indexPath = NSIndexPath(forItem: enlargedPhoto!.index, inSection: 0)
        let photoCell = collectionView.cellForItemAtIndexPath(indexPath)
        let attributes = collectionView.layoutAttributesForItemAtIndexPath(indexPath)
        let frame = view.convertRect(attributes.frame, fromView: collectionView)

        shouldHideStatusBar = false
        setNeedsStatusBarAppearanceUpdate()

        photoCell.hidden = true
        self.enlargedPhoto!.imageView.backgroundColor = nil
        UIView.animateWithDuration(0.4,
            delay: 0,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 0.5,
            options: .AllowUserInteraction,
            animations: {
                self.enlargedPhoto!.imageView.frame = frame
                self.enlargedPhoto!.backgroundColor = nil
            },
            completion: { _ in
                HighResImageDownloader.cancel()
                photoCell.hidden = false
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
            if let highResPhoto = highResPhotos[indexPath.item] {
                cell.imageButton.setBackgroundImage(highResPhoto, forState: .Normal)
            } else {
                cell.imageButton.setBackgroundImage(photos[indexPath.item], forState: .Normal)
            }
            cell.imageButton.tag = indexPath.item
            return cell
    }

}
