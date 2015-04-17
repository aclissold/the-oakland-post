//
//  EnlargedPhoto.swift
//  The Oakland Post
//
//  A full-screen, high-res, zoomable, pannable, dismissable photo.
//
//  Created by Andrew Clissold on 7/23/14.
//  Copyright (c) 2014 Andrew Clissold. All rights reserved.
//


class EnlargedPhoto: UIView {

    required init(coder aDecoder: NSCoder) { fatalError("wrong initializer") }

    let imageView: UIImageView
    let scrollView: UIScrollView
    var highResImageView: UIImageView!
    var linkButton: UIButton!
    var index: Int!
    private let text = NSAttributedString(string: "View post ➔",
        attributes: [
            NSFontAttributeName: UIFont(name: sansSerifName, size: 17)!,
            NSForegroundColorAttributeName: UIColor.whiteColor()
        ])

    init(image: UIImage!, index: Int) {
        let window = UIApplication.sharedApplication().windows[0] as! UIWindow

        imageView = UIImageView(image: image)
        scrollView = UIScrollView(frame: window.frame)

        imageView.backgroundColor = UIColor.blackColor()
        imageView.clipsToBounds = true
        imageView.contentMode = .ScaleAspectFit
        imageView.frame = window.frame
        imageView.userInteractionEnabled = true

        linkButton = UIButton()
        linkButton.tag = index
        linkButton.setAttributedTitle(text, forState: .Normal)
        linkButton.contentHorizontalAlignment = .Left
        linkButton.frame.size = CGSize(width: window.frame.size.width, height: 30)
        linkButton.frame.origin = CGPoint(x: 8, y: window.frame.size.height - linkButton.frame.size.height)

        scrollView.contentSize = imageView.frame.size
        scrollView.maximumZoomScale = 2
        scrollView.minimumZoomScale = 1
        scrollView.addSubview(imageView)

        super.init(frame: window.frame)
        alpha = 0
        backgroundColor = UIColor.blackColor()
        self.index = index
        addSubview(scrollView)
        addSubview(linkButton)
    }

}
