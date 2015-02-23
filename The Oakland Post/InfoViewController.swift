//
//  InfoViewController.swift
//  The Oakland Post
//
//  Content view controller for About Us, Contact Us, and Staff.
//
//  Created by Andrew Clissold on 7/2/14.
//  Copyright (c) 2014 Andrew Clissold. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController, UIPageViewControllerDataSource {

    @IBOutlet weak var biosToolbar: UIToolbar!
    @IBOutlet weak var toolbarVerticalConstraint: NSLayoutConstraint!
    @IBOutlet weak var toolbarHeightConstraint: NSLayoutConstraint!

    let pageTitles = ["About Us", "Contact Us", "Staff"]
    let transitionManager = InfoTransitionManager()

    var pageViewController: UIPageViewController!
    var viewControllers: [InfoContentViewController?] = [nil, nil, nil]
    var titleLabel: UILabel!
    var topToolbar: UIToolbar!

    override func viewDidLoad() {
        super.viewDidLoad()

        homeViewController.tableView.scrollsToTop = false

        // Create the page view controller.
        pageViewController = UIPageViewController(transitionStyle: .Scroll,
            navigationOrientation: .Horizontal, options: nil)
        pageViewController.dataSource = self

        // Set the initially displayed InfoContentViewController.
        pageViewController.setViewControllers([viewControllerAtIndex(0)],
            direction: .Forward, animated: false, completion: nil
        )

        addChildViewController(pageViewController)
        pageViewController.didMoveToParentViewController(self)
        view.addSubview(pageViewController.view)
        pageViewController.view.frame.size.height -= biosToolbar.frame.size.height

        view.addSubview(biosToolbar)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        addTopToolbar()
    }

    func addTopToolbar() {
        topToolbar = UIToolbar()
        topToolbar.frame.size.width = view.frame.size.width
        topToolbar.frame.size.height = topToolbarHeight
        view.addSubview(topToolbar)

        let doneButton = UIBarButtonItem(title: "Done", style: .Done, target: self, action: "dismiss")
        doneButton.tintColor = oaklandPostBlue
        topToolbar.items = [doneButton]

        titleLabel = UILabel()
        titleLabel.frame = topToolbar.frame
        titleLabel.frame.size.height -= 17
        titleLabel.frame.origin.y += 17
        let text = toolbarTitleText((viewControllerAtIndex(0) as! InfoContentViewController).titleText)
        titleLabel.textAlignment = .Center
        titleLabel.attributedText = text
        topToolbar.addSubview(titleLabel)
    }

    func dismiss() {
        transitioningDelegate = nil // will crash if not nil
        homeViewController.tableView.scrollsToTop = true
        homeViewController.unwindToHomeViewController()
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch (segue.identifier!) {
        case biosID1, biosID2, biosID3:
            let toViewController = segue.destinationViewController as! UIViewController
            toViewController.modalPresentationStyle = .CurrentContext
            toViewController.transitioningDelegate = transitionManager
        default:
            p("unknown segue identifier: \(segue.identifier)")
        }
    }

    // MARK: UIPageViewControllerDataSource

    func pageViewController(pageViewController: UIPageViewController,
        viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
            let index = (viewController as! InfoContentViewController).pageIndex
            return viewControllerAtIndex(index + 1)
    }

    func pageViewController(pageViewController: UIPageViewController,
        viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
            let index = (viewController as! InfoContentViewController).pageIndex
            return viewControllerAtIndex(index - 1)
    }

    // Returns one of the content view controllers for About Us, Contact Us, or Staff,
    // initializing it if necessary.
    func viewControllerAtIndex(index: Int) -> UIViewController! {
        if index < 0 || index >= pageTitles.count {
            // Out of bounds.
            return nil
        }

        if viewControllers[index] == nil {
            let infoContentViewController = storyboard!.instantiateViewControllerWithIdentifier(
                infoContentViewControllerID) as! InfoContentViewController
            infoContentViewController.pageIndex = index
            infoContentViewController.titleText = pageTitles[index]

            viewControllers[index] = infoContentViewController
        }

        return viewControllers[index]
    }

    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return pageTitles.count
    }

    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return (pageViewController.viewControllers[0] as! InfoContentViewController).pageIndex;
    }

}
