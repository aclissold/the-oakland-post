//
//  PostViewController.swift
//  The Oakland Post
//
//  Created by Andrew Clissold on 6/13/14.
//  Copyright (c) 2014 Andrew Clissold. All rights reserved.
//

import UIKit

class PostViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet var webView: UIWebView

    var loadCount = 0
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

        webView.delegate = self
        webView.alpha = 0

        self.configureView()
    }

    // MARK: SVProgressHUD management

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if loadCount > 0 {
            SVProgressHUD.show()
        }
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        SVProgressHUD.dismiss()
    }

    func webView(webView: UIWebView!, didFailLoadWithError error: NSError!) {
        --loadCount
    }

    func webViewDidStartLoad(webView: UIWebView!) {
        ++loadCount
    }

    func webViewDidFinishLoad(webView: UIWebView!) {
        --loadCount
        if loadCount == 0 {
            UIView.animateWithDuration(0.15) { webView.alpha = 1 }
            SVProgressHUD.dismiss()
        }
    }

}
