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
            NSBundle.mainBundle().pathForResource(titleText, ofType: "html")
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

    deinit {
        view.removeFromSuperview()
    }

}
