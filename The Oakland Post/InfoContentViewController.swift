//
//  InfoContentViewController.swift
//  The Oakland Post
//
//  Created by Andrew Clissold on 7/2/14.
//  Copyright (c) 2014 Andrew Clissold. All rights reserved.
//

import UIKit

class InfoContentViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoText: UITextView!

    var pageIndex: Int!
    var titleText: String!

    override func viewDidLoad() {
        let fileURL = NSURL(fileURLWithPath:
            NSBundle.mainBundle().pathForResource(titleText, ofType: "html")
        )

        titleLabel.text = titleText

        infoText.attributedText = NSAttributedString(
            fileURL: fileURL,
            options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                      NSCharacterEncodingDocumentAttribute: NSUTF8StringEncoding],
            documentAttributes: nil, error: nil
        )
    }

    @IBAction func dismiss() {
        println("temporarily disabled")
    }

}
