//
//  PostViewController.swift
//  The Oakland Post
//
//  Created by Andrew Clissold on 6/13/14.
//  Copyright (c) 2014 Andrew Clissold. All rights reserved.
//

import UIKit

class PostViewController: UIViewController, UIWebViewDelegate, UIScrollViewDelegate {

    @IBOutlet weak var webView: UIWebView!

    var loadCount = 0
    var finishedLoading = false
    var URL: String? {
        didSet {
            URL = URL!.stringByReplacingOccurrencesOfString("//www", withString: "//m")
        }
    }

    func configureView() {
        if let string = self.URL {
            let URL = NSURL(string: string)
            let request = NSURLRequest(URL: URL)
            self.webView.loadRequest(request)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        webView.delegate = self
        webView.alpha = 0
        webView.scrollView.delegate = self

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

    // MARK: Bar Hiding Animations

    var didAppear = false

    var minDelta: CGFloat = 0
    var maxDelta: CGFloat = 0
    var previousPosition: CGFloat = 0
    var totalDelta: CGFloat = 0
    var originalY: CGFloat = 0

    var wasDecelerating = false

    override func viewDidAppear(animated: Bool) {
        didAppear = true
        maxDelta = tabBarController.tabBar.frame.size.height
        originalY = tabBarController.tabBar.frame.origin.y
    }

    func scrollViewDidScroll(scrollView: UIScrollView!) {
        updateTabBarPosition(scrollView)
    }

    func updateTabBarPosition(scrollView: UIScrollView!) {
        if !didAppear { return } // ignore scrolling that occurs between willAppear and didAppear

        let currentPosition = scrollView.contentOffset.y + scrollView.contentInset.top
        let delta = currentPosition - previousPosition
        totalDelta += delta
        if totalDelta < minDelta { totalDelta = minDelta }
        if totalDelta > maxDelta { totalDelta = maxDelta }

        previousPosition = currentPosition

        if currentPosition < 0 {
            previousPosition = 0
            totalDelta = 0
        } // TODO: handle bottom of screen as well

        tabBarController?.tabBar.frame.origin.y = originalY + totalDelta
    }

    func scrollViewDidEndDragging(scrollView: UIScrollView!, willDecelerate decelerate: Bool) {
        if !decelerate && minDelta < totalDelta && totalDelta < maxDelta {
            resetTabBarPosition()
        }
        self.wasDecelerating = decelerate
    }

    func scrollViewDidEndDecelerating(scrollView: UIScrollView!) {
        if wasDecelerating && (minDelta < totalDelta && totalDelta < maxDelta) {
            resetTabBarPosition()
        }
    }

    func resetTabBarPosition() {
        if tabBarController == nil { return } // TODO

        let amountHidden = totalDelta / maxDelta

        var y: CGFloat
        if amountHidden < 0.5 {
            y = originalY
            totalDelta = 0
        } else {
            y = originalY + maxDelta
            totalDelta = maxDelta
        }

        let duration = NSTimeInterval(0.1 * amountHidden)
        UIView.animateWithDuration(duration) {
            self.tabBarController.tabBar.frame.origin.y = y
        }
    }

    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        resetTabBarPosition()
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
                    message: request.URL.absoluteString!,
                    delegate: delegate,
                    cancelButtonTitle: "No",
                    otherButtonTitles: "Yes").show()
                return false
            }
    }

}
