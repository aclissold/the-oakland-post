//
//  PhotosViewController.swift
//  The Oakland Post
//
//  Tab 3.
//
//  A grid view of tappable photos from posts.
//
//  Created by Andrew Clissold on 7/5/14.
//  Copyright (c) 2014 Andrew Clissold. All rights reserved.
//

import UIKit

class PhotosViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout,
    NHBalancedFlowLayoutDelegate, UICollectionViewDataSource, TopScrollable {

    let baseURL = "http://www.oaklandpostonline.com/search/?t=article"

    var photos = [UIImage]()
    var highResPhotos = [Int: UIImage]()
    var URLs = [String]()

    var enlargedPhoto: EnlargedPhoto?
    var gestureRecognizers: EnlargedPhotoGestureRecognizers!

    var feedParser: FeedParser!
    var finishedParsing = false

    var canScrollToTop = false

    var enlargedPhotoDelegate: EnlargedPhotoDelegate!

    // MARK: Lifecycle

    override func viewDidLoad() {
        let delegate = PhotosFeedParserDelegate(delegator: self)
        feedParser = FeedParser(baseURL: baseURL, length: 15, delegate: delegate)
        feedParser.parseInitial()

        enlargedPhotoDelegate = EnlargedPhotoDelegate(delegator: self)

        collectionView!.addInfiniteScrollingWithActionHandler(parseMore)

        gestureRecognizers = EnlargedPhotoGestureRecognizers(photosViewController: self)

        navigationController!.navigationBar.layer.zPosition = 1
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        canScrollToTop = true
        if photos.count == 0 && finishedParsing {
            // Initial parse failed; try again.
            feedParser.parseInitial()
        } else if !finishedParsing {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            SVProgressHUD.show()
        }
    }

    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        canScrollToTop = false
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        SVProgressHUD.dismiss()
    }

    override func viewWillLayoutSubviews() {
        let window = UIApplication.sharedApplication().windows[0] as! UIWindow
        if let photo = enlargedPhoto {
            photo.frame = window.frame
        }
    }

    // MARK: Miscellaneous

    func parseMore() {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        tabBarController!.tabBar.userInteractionEnabled = false
        feedParser.parseMore()
    }

    func scrollToTop() {
        let rect = CGRect(origin: CGPointZero, size: CGSize(width: 1, height: 1))
        collectionView!.scrollRectToVisible(rect, animated: true)
    }

    // MARK: Enlarged Photo Handling

    var shouldHideStatusBar = false
    let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.height
    override func prefersStatusBarHidden() -> Bool {
        return shouldHideStatusBar
    }

    func receivePhoto(photo: UIImage, forIndex index: Int) {
        highResPhotos[index] = photo
    }

    // Displays a full-screen, high-res version of the tapped photo cell, with a link to its respective post.
    @IBAction func addEnlargedPhoto(sender: UIButton) {
        if enlargedPhoto != nil { return } // the user probably tapped two at once

        let index = sender.tag

        if let highResPhoto = highResPhotos[index] {
            enlargedPhoto = EnlargedPhoto(image: highResPhoto, index: index)
        } else {
            enlargedPhoto = EnlargedPhoto(image: photos[index], index: index)
            downloadHighResImageFromURL(URLs[index],
                forEnlargedPhoto: enlargedPhoto!,
                sender: sender, finished: self.receivePhoto)
        }
        enlargedPhoto!.scrollView.delegate = enlargedPhotoDelegate

        enlargedPhoto!.linkButton.addTarget(self, action: "showPost:", forControlEvents: .TouchUpInside)
        gestureRecognizers.addToEnlargedPhoto(enlargedPhoto!)

        navigationController!.view.addSubview(enlargedPhoto!)

        shouldHideStatusBar = true
        setNeedsStatusBarAppearanceUpdate()
        navigationController!.navigationBar.frame.size.height += statusBarHeight

        UIView.animateWithDuration(0.15,
            delay: 0,
            options: nil,
            animations: {
                self.enlargedPhoto!.alpha = 1
                self.navigationController!.navigationBar.frame.origin.y -=
                    self.navigationController!.navigationBar.frame.size.height
                self.tabBarController!.tabBar.frame.origin.y +=
                    self.tabBarController!.tabBar.frame.size.height
            },
            completion: { _ in
                self.navigationController!.navigationBarHidden = true
            })
    }

    func showPost(sender: UIButton) {
        performSegueWithIdentifier("showPost", sender: NSNumber(int: Int32(sender.tag)))
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showPost" {
            let themedNavigationController = (segue.destinationViewController as! ThemedNavigationController)
            let postViewController = (themedNavigationController.childViewControllers[0] as! PostViewController)
            postViewController.navigationItem.rightBarButtonItem =
                UIBarButtonItem(title: "Done", style: .Done, target: self, action: "dismissModalPost")
            postViewController.URL = URLs[(sender as! NSNumber).integerValue]
        }
    }

    func dismissModalPost() {
        dismissViewControllerAnimated(true, completion: nil)
    }

    // MARK: NHBalancedFlowLayoutDelegate

    func collectionView(collectionView: UICollectionView!,
        layout collectionViewLayout: NHBalancedFlowLayout!,
        preferredSizeForItemAtIndexPath indexPath: NSIndexPath!) -> CGSize {
            if UIScreen.mainScreen().scale == 1.0 {
                var size = photos[indexPath.item].size
                size.width /= 2
                size.height /= 2
                return size
            }
            return photos[indexPath.item].size
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }

    override func collectionView(collectionView: UICollectionView,
        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(photoCellID,
                forIndexPath: indexPath) as! PhotoCell
            if let highResPhoto = highResPhotos[indexPath.item] {
                cell.imageButton.setBackgroundImage(highResPhoto, forState: .Normal)
            } else {
                cell.imageButton.setBackgroundImage(photos[indexPath.item], forState: .Normal)
            }
            cell.imageButton.tag = indexPath.item
            return cell
    }

}
