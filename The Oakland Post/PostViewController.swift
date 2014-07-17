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

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        SVProgressHUD.dismiss()
    }

    func webView(webView: UIWebView!, didFailLoadWithError error: NSError!) {
        --loadCount
    }

    func webViewDidStartLoad(webView: UIWebView!) {
        if ++loadCount == 1 {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            SVProgressHUD.show()
        }
    }

    func webViewDidFinishLoad(webView: UIWebView!) {
        --loadCount
        if loadCount == 0 {
            UIView.animateWithDuration(0.15) { webView.alpha = 1 }
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            SVProgressHUD.dismiss()
        }
    }

}
