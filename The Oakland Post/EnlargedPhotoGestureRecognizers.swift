//
//  EnlargedPhotoGestureRecognizers.swift
//  The Oakland Post
//
//  EnlargedPhoto dismissal and related gesture recognizers.
//
//  Created by Andrew Clissold on 7/30/14.
//  Copyright (c) 2014 Andrew Clissold. All rights reserved.
//

class EnlargedPhotoGestureRecognizers: NSObject {

    let photosViewController: PhotosViewController
    var photo: EnlargedPhoto!

    init(photosViewController: PhotosViewController) {
        self.photosViewController = photosViewController
        super.init()
    }

    // Creates and adds all gestures to an EnlargedPhoto instance.
    func addToEnlargedPhoto(enlargedPhoto: EnlargedPhoto) {
        photo = enlargedPhoto

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "singleTapReceived:")
        let doubleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: "doubleTapReceived:")
        let swipeUpGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "swipeReceived:")
        let swipeDownGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "swipeReceived:")

        doubleTapGestureRecognizer.numberOfTapsRequired = 2
        tapGestureRecognizer.requireGestureRecognizerToFail(doubleTapGestureRecognizer)
        swipeUpGestureRecognizer.direction = .Up
        swipeDownGestureRecognizer.direction = .Down

        photo.addGestureRecognizer(tapGestureRecognizer)
        photo.addGestureRecognizer(doubleTapGestureRecognizer)
        photo.addGestureRecognizer(swipeUpGestureRecognizer)
        photo.addGestureRecognizer(swipeDownGestureRecognizer)
    }


    // Zooms out if zoomed and dismisses if zoomed out.
    func singleTapReceived(recognizer: UITapGestureRecognizer) {
        if recognizer.state == .Ended {
            if photo.scrollView.zoomScale == 1.0 {
                removeEnlargedPhoto()
            } else {
                photo.scrollView.zoomToRect(photo.frame, animated: true)
            }
        }
    }

    // Zooms out if zoomed in and vice versa.
    func doubleTapReceived(recognizer: UITapGestureRecognizer) {
        if recognizer.state == .Ended {
            switch photo.scrollView.zoomScale {
            case 1.0:
                let point = recognizer.locationOfTouch(0, inView: photo)
                photo.scrollView.zoomToPoint(point, withScale: 2.0, animated: true)
            default:
                photo.scrollView.zoomToRect(photo.frame, animated: true)
            }
        }
    }

    // Dismisses.
    func swipeReceived(recognizer: UISwipeGestureRecognizer) {
        if recognizer.state == .Ended {
            removeEnlargedPhoto()
        }
    }

    func removeEnlargedPhoto() {
        // Remove all gesture recognizers.
        for recognizer in photo.gestureRecognizers as! [UIGestureRecognizer] {
            photo.removeGestureRecognizer(recognizer)
        }

        // Find the photo cell.
        let indexPath = NSIndexPath(forItem: photo.index, inSection: 0)
        let photoCell = photosViewController.collectionView!.cellForItemAtIndexPath(indexPath)!

        // Compute the frame.
        let attributes = photosViewController.collectionView!.layoutAttributesForItemAtIndexPath(indexPath)!
        var frame = photosViewController.view.convertRect(attributes.frame, fromView: photosViewController.collectionView)
        let navigationBarHeight = photosViewController.navigationController!.navigationBar.frame.size.height
        let statusBarHeight: CGFloat = 20 // hard-coded because it's invisible at this point, i.e. 0.0
        frame.origin.y += (navigationBarHeight + statusBarHeight)

        // Prepare for animation.

        photosViewController.shouldHideStatusBar = false
        photosViewController.setNeedsStatusBarAppearanceUpdate()
        photosViewController.navigationController!.setNavigationBarHidden(false, animated: false)
        photoCell.hidden = true
        photo.imageView.backgroundColor = nil

        // Animate dismissal.
        UIView.animateWithDuration(0.4,
            delay: 0,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 0.5,
            options: .AllowUserInteraction,
            animations: {
                self.photo.imageView.frame = frame
                self.photo.backgroundColor = nil
            },
            completion: { _ in
                cancelDownloadingHighResImage()
                photoCell.hidden = false
                self.photo.removeFromSuperview()
                self.photo = nil
                self.photosViewController.enlargedPhoto = nil
            }
        )

        // Un-hide the tab bar.
        UIView.animateWithDuration(0.15) {
            self.photosViewController.tabBarController!.tabBar.frame.origin.y -=
                self.photosViewController.tabBarController!.tabBar.frame.size.height
        }
    }

}
