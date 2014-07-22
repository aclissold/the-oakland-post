//
//  PostViewController.swift
//  The Oakland Post
//
//  Created by Andrew Clissold on 6/13/14.
//  Copyright (c) 2014 Andrew Clissold. All rights reserved.
//

import UIKit

class PostViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!

    var loadCount = 0
    var finishedLoading = false
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

    // MARK: UIWebViewDelegate

    // private
    // TODO: break this into a multiline string once Swift doesn't crash trying to compile it
    let script = "document.getElementById('mobile-header').style.display = 'none'; document.getElementById('mobile-search-bar').style.display = 'none'; document.getElementsByClassName('menu not-iphone')[0].style.display = 'none'; document.getElementsByTagName('h1')[1].style.fontFamily = 'Avenir Next'; document.getElementsByClassName('byline')[0].style.fontFamily = 'Avenir Next'; document.getElementById('blox-story-text').style.fontFamily = 'Palatino'; document.getElementById('blox-story-text').style.lineHeight = '150%';"

    func webViewDidFinishLoad(webView: UIWebView!) {
        --loadCount
        if loadCount == 0 {
            finishedLoading = true

            // Hide the header and footer and style the text
            webView.stringByEvaluatingJavaScriptFromString(script)

            // Emulate a callback waiting for the web view to finish drawing
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 67_000_000), dispatch_get_main_queue()) {
                UIView.animateWithDuration(0.15) { webView.alpha = 1 }
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                SVProgressHUD.dismiss()
            }
        }
    }

    // MARK: Handling External Links

    var delegate: LinkAlertDelegate!

    func webView(webView: UIWebView!,
        shouldStartLoadWithRequest request: NSURLRequest!,
        navigationType: UIWebViewNavigationType) -> Bool {
            if !finishedLoading {
                return true
            } else {
                delegate = LinkAlertDelegate(URL: request.URL)
                UIAlertView(title: "Open External Link?",
                    message: request.URL.absoluteString,
                    delegate: delegate,
                    cancelButtonTitle: "No",
                    otherButtonTitles: "Yes").show()
                return false
            }
    }

}
