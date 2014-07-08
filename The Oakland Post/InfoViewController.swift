//
//  InfoViewController.swift
//  The Oakland Post
//
//  Created by Andrew Clissold on 7/2/14.
//  Copyright (c) 2014 Andrew Clissold. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController, UIPageViewControllerDataSource {

    let pageTitles: [String] = ["About Us", "Contact Us", "Staff"]

    var pageViewController: UIPageViewController!
    var viewControllers: [InfoContentViewController] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Create the page view controller.
        pageViewController = UIPageViewController(transitionStyle: .Scroll,
            navigationOrientation: .Horizontal, options: nil)
        pageViewController.dataSource = self

        // Create the three content view controllers for the page view controller.
        for (index, title) in enumerate(pageTitles) {
            var infoContentViewController = storyboard.instantiateViewControllerWithIdentifier(
                infoContentViewControllerID) as InfoContentViewController
            infoContentViewController.titleText = title
            infoContentViewController.pageIndex = index

            viewControllers.append(infoContentViewController)
        }

        // Set the initially displayed InfoContentViewController.
        pageViewController.setViewControllers([viewControllers[0]],
            direction: .Forward, animated: false, completion: nil
        )

        addChildViewController(pageViewController)
        pageViewController.didMoveToParentViewController(self)
        view.addSubview(pageViewController.view)
    }

    // MARK: UIPageViewControllerDataSource

    func pageViewController(pageViewController: UIPageViewController!,
        viewControllerAfterViewController viewController: UIViewController!) -> UIViewController! {
            let index = (viewController as InfoContentViewController).pageIndex
            return viewControllerAtIndex(index + 1)
    }

    func pageViewController(pageViewController: UIPageViewController!,
        viewControllerBeforeViewController viewController: UIViewController!) -> UIViewController! {
            let index = (viewController as InfoContentViewController).pageIndex
            return viewControllerAtIndex(index - 1)
    }

    func viewControllerAtIndex(index: Int) -> UIViewController! {
        if index < 0 || index >= pageTitles.count {
            return nil
        }

        return viewControllers[index]
    }

    func presentationCountForPageViewController(pageViewController: UIPageViewController!) -> Int {
        return pageTitles.count
    }

    func presentationIndexForPageViewController(pageViewController: UIPageViewController!) -> Int {
        return (pageViewController.viewControllers[0] as InfoContentViewController).pageIndex;
    }

}
