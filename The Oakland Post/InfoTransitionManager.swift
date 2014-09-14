//
//  InfoTransitionManager.swift
//  The Oakland Post
//
//  Created by Andrew Clissold on 9/14/14.
//  Copyright (c) 2014 Andrew Clissold. All rights reserved.
//

class InfoTransitionManager: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {

    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        // Retrieve references to the view controllers.
        var biosViewController: BiosViewController!
        var infoViewController: InfoViewController!
        var presenting = true // true if showing, false if dismissing
        if transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) is InfoViewController {
            biosViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as BiosViewController
            infoViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as InfoViewController
        } else {
            presenting = false
            biosViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as BiosViewController
            infoViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as InfoViewController
        }

        // Retrieve references to the views to animate.
        let containerView = transitionContext.containerView()
        let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)!
        let toView = transitionContext.viewForKey(UITransitionContextToViewKey)!
        let infoToolbar = biosViewController.infoToolbar
        let biosToolbar = infoViewController.biosToolbar
        var toolbarHeightConstraint: NSLayoutConstraint!
        var toolbarVerticalConstraint: NSLayoutConstraint!
        if presenting {
            toolbarHeightConstraint = biosViewController.toolbarHeightConstraint
            toolbarVerticalConstraint = biosViewController.toolbarVerticalConstraint
        } else {
            toolbarHeightConstraint = infoViewController.toolbarHeightConstraint
            toolbarVerticalConstraint = infoViewController.toolbarVerticalConstraint
        }

        fromView.frame = containerView.frame
        toView.frame = containerView.frame

        infoViewController.biosToolbar.hidden = presenting
        biosViewController.infoToolbar.hidden = !presenting

        // Add the subviews so that the visible toolbar is on top.
        containerView.addSubview(fromView)
        containerView.addSubview(toView)
        containerView.backgroundColor = presenting ? toView.backgroundColor : UIColor(white: 0.96, alpha: 1)

        // Prepare the views for animation.
        if presenting {
            toView.frame.origin.y += toView.frame.size.height
            infoToolbar.frame.origin.y -= infoToolbar.frame.size.height
            toolbarHeightConstraint.constant = 44
            toolbarVerticalConstraint.constant = -toolbarHeightConstraint.constant
        } else {
            toView.frame.origin.y -= toView.frame.size.height
            infoToolbar.frame.origin.y += infoToolbar.frame.size.height
            toolbarHeightConstraint.constant = 66
            toolbarVerticalConstraint.constant = -toolbarHeightConstraint.constant
        }

        let duration = transitionDuration(transitionContext)

        // Perform the animations.
        toView.layoutIfNeeded()
        UIView.animateWithDuration(duration, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {
            if presenting {
                fromView.frame.origin.y -= toView.frame.size.height
                toView.frame.origin.y -= toView.frame.size.height
            } else {
                fromView.frame.origin.y += toView.frame.size.height
                toView.frame.origin.y += toView.frame.size.height
            }
            toolbarVerticalConstraint.constant = 0
            toolbarHeightConstraint.constant = presenting ? 66 : 44
            toView.layoutIfNeeded()
        }) { finished in
            transitionContext.completeTransition(finished)
        }
    }

    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return 0.5
    }

    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController,
        sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }

    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }

}
