//
//  InfoViewController.swift
//  The Oakland Post
//
//  Created by Andrew Clissold on 7/2/14.
//  Copyright (c) 2014 Andrew Clissold. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController, UIPageViewControllerDataSource {

    var pageViewController: UIPageViewController!
    var pageTitles: Array<String>!

    override func viewDidLoad() {
        super.viewDidLoad()

        pageTitles = ["About Us", "Contact Us", "Staff"]

        pageViewController = storyboard.instantiateViewControllerWithIdentifier(
            pageViewControllerID) as UIPageViewController
        pageViewController.dataSource = self

        let startingViewController = viewControllerAtIndex(0)
        let viewControllers = [startingViewController]
        pageViewController.setViewControllers(viewControllers,
            direction: .Forward, animated: false, completion: nil)

        pageViewController.view.frame = CGRect(x: 0.0, y: 0.0,
            width: view.frame.size.width, height: view.frame.size.height - 30.0)
        addChildViewController(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.didMoveToParentViewController(self)
    }

    // MARK: UIPageViewControllerDataSource

    func pageViewController(pageViewController: UIPageViewController!,
        viewControllerAfterViewController viewController: UIViewController!) -> UIViewController! {
            var index = (viewController as InfoContentViewController).pageIndex
            if index == 0 || index == NSNotFound {
                return nil
            }
            index = index - 1
            return viewControllerAtIndex(index)
    }

    func pageViewController(pageViewController: UIPageViewController!,
        viewControllerBeforeViewController viewController: UIViewController!) -> UIViewController! {
            var index = (viewController as InfoContentViewController).pageIndex
            if index == NSNotFound {
                return nil
            }
            index = index + 1
            if index == pageTitles.count {
                return nil
            }
            return viewControllerAtIndex(index)
    }

    func viewControllerAtIndex(index: Int) -> UIViewController! {
        if pageTitles.count == 0 || index >= pageTitles.count {
            return nil
        }

        // Create the relevant instance of InfoContentViewController.
        var infoContentViewController = storyboard.instantiateViewControllerWithIdentifier(
            infoContentViewControllerID) as InfoContentViewController
        infoContentViewController.titleText = pageTitles[index]
        infoContentViewController.pageIndex = index

        return infoContentViewController
    }

    func presentationCountForPageViewController(pageViewController: UIPageViewController!) -> Int {
        return pageTitles.count
    }

    func presentationIndexForPageViewController(pageViewController: UIPageViewController!) -> Int {
        return 0;
    }
}