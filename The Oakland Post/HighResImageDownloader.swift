//
//  HighResImageDownloader.swift
//  The Oakland Post
//
//  Functions to find and download the high-res photo corresponding to a PhotoCell.
//
//  Created by Andrew Clissold on 7/26/14.
//  Copyright (c) 2014 Andrew Clissold. All rights reserved.
//

private var downloadOperation: SDWebImageOperation?
private var canceled = false

func downloadHighResImageFromURL(URL: String, forEnlargedPhoto enlargedPhoto: EnlargedPhoto,
    sender: UIButton, finished: (UIImage, Int) -> ()) {

    canceled = false // reset

    // Download progressed callback.
    func downloadProgressed(receivedSize: Int, expectedSize: Int) {
        if expectedSize <= 0 { return }
        let progress = Float(receivedSize) / Float(expectedSize)
        onMain { SVProgressHUD.showProgress(progress) }
    }

    // Download finished callback.
    // This is a let closure instead of a function because local functions cannot reference
    // other local functions. Specifically, finished() can only be called this way.
    let downloadFinished: SDWebImageDownloaderCompletedBlock = { (image, data, error, _) in
        onMain {
            SVProgressHUD.dismiss()
            guard !canceled, let image = image else { return }
            enlargedPhoto.imageView.image = image
            sender.setBackgroundImage(image, forState: .Normal)
            finished(image, sender.tag)
        }
    }

    onMain { SVProgressHUD.showProgress(0) }

    onDefault {
        // Find the image URL.
        guard let pageURL = NSURL(string: URL),
            let HTMLData = NSData(contentsOfURL: pageURL) else {
                cancelDownloadingHighResImage()
                return
        }
        let hpple = TFHpple(HTMLData: HTMLData)
        let XPathQuery = "//meta[@property='og:image']"
        let elements = hpple.searchWithXPathQuery(XPathQuery) as! [TFHppleElement]

        if elements.count == 0 {
            cancelDownloadingHighResImage()
            return
        }

        guard let imageURLString = elements[0].objectForKey("content") as? String,
            let imageURL = NSURL(string: imageURLString) else {
                cancelDownloadingHighResImage()
                return
        }

        // Download the image at that URL.
        if !canceled {
            downloadOperation = SDWebImageDownloader.sharedDownloader().downloadImageWithURL(
                imageURL, options: SDWebImageDownloaderOptions(rawValue: 0),
                progress: downloadProgressed, completed: downloadFinished)
        }
    }
}

func cancelDownloadingHighResImage() {
    onMain { SVProgressHUD.dismiss() }
    downloadOperation?.cancel()
    canceled = true
}
