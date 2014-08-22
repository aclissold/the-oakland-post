//
//  HighResImageDownloader.swift
//  The Oakland Post
//
//  Created by Andrew Clissold on 7/26/14.
//  Copyright (c) 2014 Andrew Clissold. All rights reserved.
//

// TODO: make these class vars when Swift enables them
private var downloadOperation: SDWebImageOperation?
private var canceled = false

class HighResImageDownloader {

    class func downloadFromURL(URL: String,
        forEnlargedPhoto enlargedPhoto: EnlargedPhoto, sender: UIButton, finished: (UIImage, Int) -> ()) {

        canceled = false // reset

        // TODO: turn these let closures back into local functions? They broke in Beta 6.
        let downloadProgressed: (Int, Int) -> Void = { (receivedSize: Int, expectedSize: Int) in
            let progress = Float(receivedSize) / Float(expectedSize)
            onMain { SVProgressHUD.showProgress(progress) }
        }

        let downloadFinished: (UIImage?, NSData?, NSError?, Bool) -> Void = { (image: UIImage?, data: NSData?, error: NSError?, _: Bool) in
            onMain {
                SVProgressHUD.dismiss()
                enlargedPhoto.imageView.image = image
                sender.setBackgroundImage(image, forState: .Normal)
                finished(image!, sender.tag)
            }
        }

        onMain { SVProgressHUD.showProgress(0) }

        onDefault {
            // Find the image URL
            let HTMLData = NSData(contentsOfURL: NSURL(string: URL))
            let dataString = NSString(data: HTMLData, encoding: NSUTF8StringEncoding)
            let hpple = TFHpple(HTMLData: HTMLData)
            let XPathQuery = "//meta[@property='og:image']"
            let elements = hpple.searchWithXPathQuery(XPathQuery) as [TFHppleElement]
            let imageURL = elements[0].objectForKey("content")

            // Download the image at that URL
            let URL = NSURL(string: imageURL)
            if !canceled {
                downloadOperation = SDWebImageDownloader.sharedDownloader().downloadImageWithURL(
                    URL, options: SDWebImageDownloaderOptions.fromRaw(0)!,
                    progress: downloadProgressed, completed: downloadFinished)
            }
        }

    }

    class func cancel() {
        SVProgressHUD.dismiss()
        downloadOperation?.cancel()
        canceled = true
    }

}
