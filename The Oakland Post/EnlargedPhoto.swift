//
//  EnlargedPhoto.swift
//  The Oakland Post
//
//  Created by Andrew Clissold on 7/23/14.
//  Copyright (c) 2014 Andrew Clissold. All rights reserved.
//


class EnlargedPhoto: UIView {

    var imageView: UIImageView
    let scrollView: UIScrollView
    let highResImageURL: String?
    var highResImageView: UIImageView!


    init(image: UIImage!, highResImageURL: String? = nil) {
        let window = UIApplication.sharedApplication().windows[0] as UIWindow

        imageView = UIImageView(image: image)
        scrollView = UIScrollView(frame: window.frame)
        self.highResImageURL = highResImageURL

        imageView.backgroundColor = UIColor.blackColor()
        imageView.clipsToBounds = true
        imageView.contentMode = .ScaleAspectFit
        imageView.frame = window.frame
        imageView.userInteractionEnabled = true

        scrollView.contentSize = imageView.frame.size
        scrollView.maximumZoomScale = 2
        scrollView.minimumZoomScale = 1
        scrollView.addSubview(imageView)

        super.init(frame: window.frame)
        alpha = 0
        backgroundColor = UIColor.blackColor()
        addSubview(scrollView)

        downloadImage()
    }

    func downloadImage() {
        if let URLString = highResImageURL {
            let URL = NSURL(string: highResImageURL)
            SDWebImageDownloader.sharedDownloader().downloadImageWithURL(
                URL, options: SDWebImageDownloaderOptions.fromRaw(0)!, progress: downloadProgressed, completed: downloadFinished)
        }
    }

    func downloadProgressed(receivedSize: Int, expectedSize: Int) {
    }

    func downloadFinished(image: UIImage?, data: NSData?, error: NSError?, finished: Bool) {
        imageView.image = image
    }

}
