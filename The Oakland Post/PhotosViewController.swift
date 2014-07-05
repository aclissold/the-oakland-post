//
//  PhotosViewController.swift
//  The Oakland Post
//
//  Created by Andrew Clissold on 7/5/14.
//  Copyright (c) 2014 Andrew Clissold. All rights reserved.
//

import UIKit

class PhotosViewController: UICollectionViewController,
    UICollectionViewDelegateFlowLayout, NHBalancedFlowLayoutDelegate, UICollectionViewDataSource {

    var photos: UIImage[] = []

    override func viewDidLoad() {
        // Theme
        self.navigationController.navigationBar.barTintColor = oaklandPostBlue
        self.navigationController.navigationBar.barStyle = .Black

        // TODO dynamically load images instead
        for URLString in
            ["http://goo.gl/1Y8DhC",
             "http://goo.gl/uRKI3h",
             "http://goo.gl/Xkiskw"] {
                let URL = NSURL(string: URLString)
                let data = NSData(contentsOfURL: URL)
                let image = UIImage(data: data)
                photos.append(image)
        }
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
