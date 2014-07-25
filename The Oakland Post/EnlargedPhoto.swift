//
//  EnlargedPhoto.swift
//  The Oakland Post
//
//  Created by Andrew Clissold on 7/23/14.
//  Copyright (c) 2014 Andrew Clissold. All rights reserved.
//


class EnlargedPhoto: UIView {

    let imageView: UIImageView
    let scrollView: UIScrollView
    let originatingURL: String?
    let highResImageView: UIImageView!


    init(image: UIImage!, highResImageURL: String? = nil) {
        let window = UIApplication.sharedApplication().windows[0] as UIWindow

        imageView = UIImageView(image: image)
        scrollView = UIScrollView(frame: window.frame)
        self.originatingURL = highResImageURL

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
        if !originatingURL { return }

        onMain {
            SVProgressHUD.showProgress(0)
        }

        onDefault {
            // Find the image URL
            let HTMLData = NSData(contentsOfURL: NSURL(string: self.originatingURL))
            let dataString = NSString(data: HTMLData, encoding: NSUTF8StringEncoding)
            let hpple = TFHpple(HTMLData: HTMLData)
            let XPathQuery = "//meta[@property='og:image']"
            let elements = hpple.searchWithXPathQuery(XPathQuery) as [TFHppleElement]
            let imageURL = elements[0].objectForKey("content")

            // Download the image at that URL
            let URL = NSURL(string: imageURL)
            SDWebImageDownloader.sharedDownloader().downloadImageWithURL(
                URL, options: SDWebImageDownloaderOptions.fromRaw(0)!,
                progress: self.downloadProgressed, completed: self.downloadFinished)
        }
    }

    func downloadProgressed(receivedSize: Int, expectedSize: Int) {
        let progress = Float(receivedSize) / Float(expectedSize)
        onMain { SVProgressHUD.showProgress(progress) }
    }

    func downloadFinished(image: UIImage?, data: NSData?, error: NSError?, finished: Bool) {
        onMain {
            SVProgressHUD.dismiss()
            self.imageView.image = image
        }
    }

}
