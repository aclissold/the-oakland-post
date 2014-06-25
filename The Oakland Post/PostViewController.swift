//
//  PostViewController.swift
//  The Oakland Post
//
//  Created by Andrew Clissold on 6/13/14.
//  Copyright (c) 2014 Andrew Clissold. All rights reserved.
//

import UIKit

class PostViewController: UIViewController {

    @IBOutlet var webView: UIWebView

    var url: String? {
        didSet {
            url = url!.stringByReplacingOccurrencesOfString("//www", withString: "//m")
        }
    }

    func configureView() {
        if let string = self.url {
            let URL = NSURL(string: string)
            let request = NSURLRequest(URL: URL)
            self.webView.loadRequest(request)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureView()
    }

}
