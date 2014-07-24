//
//  EnlargedPhoto.swift
//  The Oakland Post
//
//  Created by Andrew Clissold on 7/23/14.
//  Copyright (c) 2014 Andrew Clissold. All rights reserved.
//


class EnlargedPhoto: UIImageView {

    init(image: UIImage!) {
        super.init(image: image)

        alpha = 0
        clipsToBounds = true
        backgroundColor = UIColor.blackColor()

        contentMode = UIViewContentMode.ScaleAspectFit

        let window = UIApplication.sharedApplication().windows[0] as UIWindow
        frame = window.frame

        userInteractionEnabled = true
    }

}
