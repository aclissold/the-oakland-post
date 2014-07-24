//
//  EnlargedPhoto.swift
//  The Oakland Post
//
//  Created by Andrew Clissold on 7/23/14.
//  Copyright (c) 2014 Andrew Clissold. All rights reserved.
//


class EnlargedPhoto: UIScrollView {

    let imageView: UIImageView

    init(image: UIImage!) {
        imageView = UIImageView(image: image)

        let window = UIApplication.sharedApplication().windows[0] as UIWindow
        super.init(frame: window.frame)

        imageView.backgroundColor = UIColor.blackColor()
        imageView.clipsToBounds = true
        imageView.contentMode = .ScaleAspectFit
        imageView.frame = bounds
        imageView.userInteractionEnabled = true

        alpha = 0
        contentSize = imageView.frame.size
        maximumZoomScale = 2
        minimumZoomScale = 1

        addSubview(imageView)
    }

}
