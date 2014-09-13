//
//  InfoViewController.swift
//  The Oakland Post
//
//  Created by Andrew Clissold on 7/2/14.
//  Copyright (c) 2014 Andrew Clissold. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController, UIPageViewControllerDataSource {

    let pageTitles = ["About Us", "Contact Us", "Staff"]

    var pageViewController: UIPageViewController!
    var viewControllers: [InfoContentViewController?] = [nil, nil, nil]
    var titleLabel: UILabel!
    var toolbar: UIToolbar!

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
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        addToolbar()
    }

    func addToolbar() {
        toolbar = UIToolbar()
        toolbar.frame.size.width = view.frame.size.width
        toolbar.frame.size.height = toolbarHeight
        view.addSubview(toolbar)

        let doneButton = UIBarButtonItem(title: "Done", style: .Done, target: self, action: "dismiss")
        doneButton.tintColor = oaklandPostBlue
        toolbar.items = [doneButton]

        titleLabel = UILabel()
        titleLabel.frame = toolbar.frame
        titleLabel.frame.size.height -= 17
        titleLabel.frame.origin.y += 17
        let text = toolbarTitleText((viewControllerAtIndex(0) as InfoContentViewController).titleText)
        titleLabel.textAlignment = .Center
        titleLabel.attributedText = text
        toolbar.addSubview(titleLabel)
    }

    func dismiss() {
        homeViewController.tableView.scrollsToTop = true
        dismissViewControllerAnimated(true, completion: nil)
    }

    // MARK: UIPageViewControllerDataSource

    func pageViewController(pageViewController: UIPageViewController,
        viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
            let index = (viewController as InfoContentViewController).pageIndex
            return viewControllerAtIndex(index + 1)
    }

    func pageViewController(pageViewController: UIPageViewController,
        viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
            let index = (viewController as InfoContentViewController).pageIndex
            return viewControllerAtIndex(index - 1)
    }

    func viewControllerAtIndex(index: Int) -> UIViewController! {
        if index < 0 || index >= pageTitles.count {
            return nil
        }

        if viewControllers[index] == nil {
            let infoContentViewController = storyboard!.instantiateViewControllerWithIdentifier(
                infoContentViewControllerID) as InfoContentViewController
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
        return (pageViewController.viewControllers[0] as InfoContentViewController).pageIndex;
    }

}
