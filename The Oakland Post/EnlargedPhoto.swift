//
//  EnlargedPhoto.swift
//  The Oakland Post
//
//  Created by Andrew Clissold on 7/23/14.
//  Copyright (c) 2014 Andrew Clissold. All rights reserved.
//


class EnlargedPhoto: UIScrollView {

    private let scrollViewDelegate = ScrollViewDelegate()

    private class ScrollViewDelegate: NSObject, UIScrollViewDelegate {

        func viewForZoomingInScrollView(scrollView: UIScrollView!) -> UIView! {
            return (scrollView as EnlargedPhoto).imageView
        }

    }

    let imageView: UIImageView

    init(image: UIImage!) {
        let window = UIApplication.sharedApplication().windows[0] as UIWindow

        imageView = UIImageView(image: image)

        super.init(frame: window.frame)

        imageView.backgroundColor = UIColor.blackColor()
        imageView.clipsToBounds = true
        imageView.contentMode = .ScaleAspectFit
        imageView.frame = bounds
        imageView.userInteractionEnabled = true

        alpha = 0
        contentSize = imageView.frame.size
        delegate = scrollViewDelegate
        maximumZoomScale = 2
        minimumZoomScale = 1

        addSubview(imageView)
    }

}
