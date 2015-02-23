//
//  InfoContentViewController.swift
//  The Oakland Post
//
//  Content view controller containing one of About Us, Contact Us, or Staff.
//
//  Created by Andrew Clissold on 7/2/14.
//  Copyright (c) 2014 Andrew Clissold. All rights reserved.
//

import UIKit

class InfoContentViewController: UIViewController {

    @IBOutlet weak var infoText: UITextView!

    var pageIndex: Int!
    var titleText: String!

    override func viewDidLoad() {
        let insets = UIEdgeInsets(top: topToolbarHeight, left: 0, bottom: 0, right: 0)
        infoText.contentInset = insets
        infoText.scrollIndicatorInsets = insets
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        infoText.scrollsToTop = true
        swapOutTitleLabel()
    }

    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        infoText.scrollsToTop = false
    }

    var setAttributedText = false
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !setAttributedText {
            infoText.attributedText = infoTexts[titleText]

            // Bugfix for the scrollView not starting at the top.
            let rect = CGRect(origin: CGPointZero, size: CGSize(width: 1, height: 1))
            infoText.scrollRectToVisible(rect, animated: false)

            setAttributedText = true
        }
        infoText.frame.origin.y = 20 // bugfix for it jumping from 0 to this value on-screen
    }

    // Animates changing the title label.
    func swapOutTitleLabel() {
        let infoViewController = (parentViewController!.parentViewController as! InfoViewController)
        let titleLabel = infoViewController.titleLabel
        if titleLabel != nil && titleLabel.text != titleText {
            let originalY = infoViewController.titleLabel.frame.origin.y
            UIView.animateWithDuration(0.15,
                animations: {
                    infoViewController.titleLabel.frame.origin.y = originalY - topToolbarHeight
                },
                completion: { finished in
                    if !finished { return }
                    infoViewController.titleLabel.attributedText = toolbarTitleText(self.titleText)
                    UIView.animateWithDuration(0.4,
                        delay: 0,
                        usingSpringWithDamping: 0.6,
                        initialSpringVelocity: 0.0,
                        options: .AllowUserInteraction,
                        animations: {
                            infoViewController.titleLabel.frame.origin.y = originalY
                        }, completion: nil)
                })
        }
    }

    deinit {
        // Workaround for autolayout constraints causing EXC_BAD_ACCESS by still being accessed after deinit.
        view.removeFromSuperview()
    }

}
