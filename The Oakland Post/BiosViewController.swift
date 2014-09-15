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

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UITextView!

    @IBOutlet weak var carousel: iCarousel!
    override func viewDidLoad() {
        carousel.type = .Linear
        carousel.dataSource = self
        carousel.delegate = self

        nameLabel.text = names[0]
    }

    // MARK: iCarouselDelegate

    let names = ["Roy", "Oscar", "Yolanda", "Greta", "Bob", "Ignatius", "Veronica"]

    var firstScroll = true
    func carouselDidEndScrollingAnimation(carousel: iCarousel!) {
        // Ignore the call to this method when the view first appears.
        if firstScroll { firstScroll = false; return }

        let index = carousel.currentItemIndex
        updateContentForIndex(index)
    }

    func updateContentForIndex(index: Int) {
        let originalX = nameLabel.frame.origin.x
        let containerWidth = presentingViewController!.view.frame.size.width
        let padding: CGFloat = 20
        let duration = 0.4

        func flyOut() {
            nameLabel.frame.origin.x = containerWidth + nameLabel.frame.size.width + padding
        }

        func flyIn(finished: Bool) {
            nameLabel.text = names[index]
            nameLabel.frame.origin.x = -nameLabel.frame.size.width - padding
            UIView.animateWithDuration(duration + 0.2, delay: 0,
                usingSpringWithDamping: 0.7,
                initialSpringVelocity: 0.2,
                options: .CurveEaseOut,
                animations: {
                    self.nameLabel.frame.origin.x = originalX
                }, completion: nil)
        }

        UIView.animateWithDuration(duration, delay: 0, options: .CurveEaseIn, animations: flyOut, completion: flyIn)
    }

    // MARK: iCarouselDataSource

    func numberOfItemsInCarousel(carousel: iCarousel!) -> Int {
        return names.count
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

    // MARK: Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == biosID {
            let toViewController = segue.destinationViewController as InfoViewController
            toViewController.modalPresentationStyle = .CurrentContext
            toViewController.transitioningDelegate = toViewController.transitionManager
        }
    }

}
