//
//  PostViewController.swift
//  The Oakland Post
//
//  The content view controller to display a post in.
//
//  Created by Andrew Clissold on 6/13/14.
//  Copyright (c) 2014 Andrew Clissold. All rights reserved.
//

import UIKit

class PostViewController: UIViewController, UIWebViewDelegate, UIScrollViewDelegate {

    @IBOutlet weak var webView: UIWebView!

    var loadCount = 0 // to track when the web view is REALLY finished loading
    var finishedLoading = false
    var originalURL: String! // for sharing the post
    var URL: String! {
        didSet {
            // Mobilize.
            originalURL = URL
            URL = URL.stringByReplacingOccurrencesOfString("//www", withString: "//m")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        webView.delegate = self
        webView.alpha = 0
        webView.scrollView.delegate = self

        configureView()
    }

    func configureView() {
        if let string = self.URL {
            let URL = NSURL(string: string)!
            let request = NSURLRequest(URL: URL)
            self.webView.loadRequest(request)
        }
    }

    // Sets up and displays the share sheet.
    @IBAction func shareButtonTapped(sender: UIBarButtonItem) {
        let text = "Check out this awesome article! \(originalURL) #oaklandpost"
        let activityViewController = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        activityViewController.excludedActivityTypes = [UIActivityTypeAirDrop, UIActivityTypeCopyToPasteboard]
        presentViewController(activityViewController, animated: true, completion: nil)

        if activityViewController.respondsToSelector("popoverPresentationController") {
            // iOS 8+
            let presentationController = activityViewController.popoverPresentationController
            let rect = (navigationItem.rightBarButtonItem!.valueForKey("view") as! UIView).frame
            let origin = CGPoint(x: rect.origin.x, y: rect.origin.y + 2 * rect.size.height)

            let view = UIView(frame: CGRect(origin: origin, size: rect.size))
            presentationController?.sourceView = view
        }
    }

    // MARK: SVProgressHUD management

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        SVProgressHUD.dismiss()
        resetTabBarPosition(.Original) // see the Bar Hiding Animations MARK
    }

    func webView(webView: UIWebView, didFailLoadWithError error: NSError) {
        --loadCount
    }

    func webViewDidStartLoad(webView: UIWebView) {
        if ++loadCount == 1 {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            SVProgressHUD.show()
        }
    }

    // MARK: UIWebViewDelegate

    func webViewDidFinishLoad(webView: UIWebView) {
        --loadCount
        if loadCount == 0 {
            finishedLoading = true

            // Hide the header and footer and style the text.
            let script =
                "document.getElementById('mobile-header').style.display = 'none'; " +
                "document.getElementById('mobile-search-bar').style.display = 'none'; " +
                "document.getElementsByClassName('menu not-iphone')[0].style.display = 'none'; " +
                "document.getElementsByTagName('h1')[1].style.fontFamily = 'Avenir Next'; " +
                "document.getElementsByClassName('byline')[0].style.fontFamily = 'Avenir Next'; " +
                "document.getElementById('blox-story-text').style.fontFamily = 'Palatino'; " +
                "document.getElementById('blox-story-text').style.lineHeight = '150%';"
            webView.stringByEvaluatingJavaScriptFromString(script)

            // Emulate a callback waiting for the web view to finish drawing.
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 67_000_000), dispatch_get_main_queue()) {
                UIView.animateWithDuration(0.15) { webView.alpha = 1 }
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                SVProgressHUD.dismiss()
            }
        }
    }

    // MARK: Handling External Links

    var delegate: LinkAlertDelegate!

    func webView(webView: UIWebView,
        shouldStartLoadWithRequest request: NSURLRequest,
        navigationType: UIWebViewNavigationType) -> Bool {
            if !finishedLoading {
                return true
            } else {
                delegate = LinkAlertDelegate(URL: request.URL!)
                UIAlertView(title: "Open External Link?",
                    message: request.URL!.absoluteString!,
                    delegate: delegate,
                    cancelButtonTitle: "No",
                    otherButtonTitles: "Yes").show()
                return false
            }
    }

    // MARK: Tab Bar Hiding Animations

    private var didAppear = false

    private var minDelta: CGFloat = 0
    private var maxDelta: CGFloat = 0
    private var previousPosition: CGFloat = 0
    private var totalDelta: CGFloat = 0
    private var originalY: CGFloat = 0

    private var wasDecelerating = false
    private var reachedBottom = false

    private var overage: CGFloat {
        return webView.scrollView.contentOffset.y - (webView.scrollView.contentSize.height - view.frame.size.height)
    }

    private var retainedTabBarController: UITabBarController!

    override func viewDidAppear(animated: Bool) {
        didAppear = true
        if tabBarController != nil {
            maxDelta = tabBarController!.tabBar.frame.size.height
            originalY = tabBarController!.tabBar.frame.origin.y
            retainedTabBarController = tabBarController
        }
    }

    func scrollViewDidScroll(scrollView: UIScrollView) {
        if didAppear { // ignore scrolling that occurs between willAppear and didAppear.
            updateTabBarPosition(scrollView)
        }
    }

    func updateTabBarPosition(scrollView: UIScrollView!) {
        if tabBarController == nil { return }

        let currentPosition = scrollView.contentOffset.y + scrollView.contentInset.top
        let delta = currentPosition - previousPosition
        totalDelta += delta
        if totalDelta < minDelta { totalDelta = minDelta }
        if totalDelta > maxDelta { totalDelta = maxDelta }

        previousPosition = currentPosition

        if currentPosition < 0 {
            totalDelta = 0
        }

        if overage < 0 {
            reachedBottom = false
        }

        if reachedBottom { return }

        if overage > 0 {
            let tabBar = tabBarController!.tabBar

            if overage > tabBar.frame.size.height {
                reachedBottom = true
            }

            let atTop = tabBar.frame.origin.y == originalY
            if !atTop && (delta > 0 || !reachedBottom) {
                tabBar.frame.origin.y = max(originalY + tabBar.frame.size.height - overage, originalY)
            } else {
                tabBar.frame.origin.y = originalY
            }
        } else {
            tabBarController!.tabBar.frame.origin.y = originalY + totalDelta
        }
    }

    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate && minDelta < totalDelta && totalDelta < maxDelta {
            resetTabBarPosition(.Nearest)
        }

        if overage > 0 {
            resetTabBarPosition(.Original)
        }

        wasDecelerating = decelerate
    }

    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if wasDecelerating && (minDelta < totalDelta && totalDelta < maxDelta) {
            if overage > 0 {
                resetTabBarPosition(.Original)
            } else {
                resetTabBarPosition(.Nearest)
            }
        }
    }

    enum TabBarPosition {
        case Original, Nearest
    }

    func resetTabBarPosition(position: TabBarPosition) {
        if retainedTabBarController == nil { return }

        let amountHidden = totalDelta / maxDelta

        var y: CGFloat
        switch position {
        case .Original:
            y = originalY
        case .Nearest:
            if amountHidden < 0.5 {
                y = originalY
                totalDelta = 0
            } else {
                y = originalY + maxDelta
                totalDelta = maxDelta
            }
        }

        let duration = NSTimeInterval(0.1 * amountHidden)
        UIView.animateWithDuration(duration) {
            self.retainedTabBarController.tabBar.frame.origin.y = y
        }
    }

}
