//
//  InfoContentViewController.swift
//  The Oakland Post
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
        let fileURL = NSURL(fileURLWithPath:
            NSBundle.mainBundle().pathForResource(titleText, ofType: "html")!
        )

        infoText.attributedText = NSAttributedString(
            fileURL: fileURL,
            options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                      NSCharacterEncodingDocumentAttribute: NSUTF8StringEncoding],
            documentAttributes: nil, error: nil
        )

        let insets = UIEdgeInsets(top: toolbarHeight, left: 0, bottom: 0, right: 0)
        infoText.contentInset = insets
        infoText.scrollIndicatorInsets = insets
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        swapOutTitleLabel()
    }

    func swapOutTitleLabel() {
        let infoViewController = (parentViewController!.parentViewController as InfoViewController)
        let titleLabel = infoViewController.titleLabel
        if titleLabel != nil && titleLabel.text != titleText {
            UIView.animateWithDuration(0.15,
                animations: {
                    infoViewController.titleLabel.frame.origin.y -= toolbarHeight
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
                            infoViewController.titleLabel.frame.origin.y += toolbarHeight
                        }, completion: nil)
                })
        }
    }

    deinit {
        view.removeFromSuperview()
    }

}
