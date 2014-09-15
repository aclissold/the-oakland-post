//
//  BiosViewController.swift
//  The Oakland Post
//
//  Created by Andrew Clissold on 9/14/14.
//  Copyright (c) 2014 Andrew Clissold. All rights reserved.
//

class BiosViewController: UIViewController, iCarouselDataSource, iCarouselDelegate {

    @IBOutlet weak var infoToolbar: UIToolbar!
    @IBOutlet weak var toolbarVerticalConstraint: NSLayoutConstraint!
    @IBOutlet weak var toolbarHeightConstraint: NSLayoutConstraint!

    @IBOutlet weak var carousel: iCarousel!
    override func viewDidLoad() {
        carousel.type = .Linear
        carousel.dataSource = self
        carousel.delegate = self
    }

    // MARK: iCarouselDataSource

    func numberOfItemsInCarousel(carousel: iCarousel!) -> Int {
        return 15
    }

    func carousel(carousel: iCarousel!, viewForItemAtIndex index: Int, reusingView view: UIView!) -> UIView! {
        let hue = CGFloat(index)/CGFloat(numberOfItemsInCarousel(carousel))

        if view == nil {
            let newView = UIView(frame: CGRect(x: 0, y: 0, width: 160, height: 160))
            newView.backgroundColor = UIColor(white: 0.25, alpha: 1)
            let subview = UIView(frame: CGRect(x: 15, y: 15, width: 130, height: 130))
            subview.backgroundColor = UIColor(hue: hue, saturation: 1, brightness: 1, alpha: 1)
            newView.addSubview(subview)
            return newView
        }

        (view.subviews.first as UIView).backgroundColor = UIColor(hue: hue, saturation: 1, brightness: 1, alpha: 1)

        return view
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == biosID {
            let toViewController = segue.destinationViewController as InfoViewController
            toViewController.modalPresentationStyle = .CurrentContext
            toViewController.transitioningDelegate = toViewController.transitionManager
        }
    }

}
