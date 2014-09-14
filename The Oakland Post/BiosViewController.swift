//
//  BiosViewController.swift
//  The Oakland Post
//
//  Created by Andrew Clissold on 9/14/14.
//  Copyright (c) 2014 Andrew Clissold. All rights reserved.
//

class BiosViewController: UIViewController {

    @IBOutlet weak var infoToolbar: UIToolbar!
    @IBOutlet weak var toolbarVerticalConstraint: NSLayoutConstraint!
    @IBOutlet weak var toolbarHeightConstraint: NSLayoutConstraint!

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == biosID {
            let toViewController = segue.destinationViewController as InfoViewController
            toViewController.modalPresentationStyle = .CurrentContext
            toViewController.transitioningDelegate = toViewController.transitionManager
        }
    }

}
