//
//  BiosViewController.swift
//  The Oakland Post
//
//  Content view controller for staff bios.
//
//  Created by Andrew Clissold on 9/14/14.
//  Copyright (c) 2014 Andrew Clissold. All rights reserved.
//

class BiosViewController: UIViewController, iCarouselDataSource, iCarouselDelegate {

    @IBOutlet weak var infoToolbar: UIToolbar!
    @IBOutlet weak var toolbarVerticalConstraint: NSLayoutConstraint!
    @IBOutlet weak var toolbarHeightConstraint: NSLayoutConstraint!

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!

    @IBOutlet weak var carousel: iCarousel!
    override func viewDidLoad() {
        carousel.type = .Linear
        carousel.dataSource = self
        carousel.delegate = self

        nameLabel.text = names[0]
        descriptionTextView.attributedText = biosTexts[names[0]]
    }

    // MARK: iCarouselDelegate

    let names = ["Oona Goodin-Smith", "Kaylee Kean", "Ali DeRees", "Jackson Gilbert", "Haley Kotwicki",
        "Sean Miller", "Sélah Fischer", "Dani Cojocari", "Phillip Johnson", "Arkeem Thomas-Scott",
        "Jessie DiBattista", "Megan Carson", "Jake Alsko", "Kaleigh Jerzykowski", "Andrew Wernette",
    "Jasmine French", "Scott Davis", "Morgan Dean", "Nicolette Brikho", "Josh Soltman"]

    var previousIndex = 0
    var firstScroll = true
    func carouselDidEndScrollingAnimation(carousel: iCarousel!) {
        // Ignore the call to this method when the view first appears.
        if firstScroll { firstScroll = false; return }

        let index = carousel.currentItemIndex
        if index != previousIndex {
            updateContentForIndex(index, forward: index < previousIndex)
            previousIndex = index
        }
    }

    func updateContentForIndex(index: Int, forward: Bool) {
        if presentingViewController == nil { return } // user went back and dismissed the Info view
        let originalX = nameLabel.frame.origin.x
        let containerWidth = presentingViewController!.view.frame.size.width
        let padding: CGFloat = 20
        let duration = 0.35
        let rightPosition = containerWidth + nameLabel.frame.size.width + padding
        let leftPosition = -nameLabel.frame.size.width - padding

        func flyOut() {
            self.nameLabel.frame.origin.x = forward ? rightPosition : leftPosition
            self.descriptionTextView.alpha = 0
        }

        func flyIn(finished: Bool) {
            let name = self.names[index]
            self.nameLabel.text = self.names[index]
            self.nameLabel.frame.origin.x = forward ? leftPosition : rightPosition
            self.descriptionTextView.attributedText = biosTexts[name]
            UIView.animateWithDuration(duration) {
                self.descriptionTextView.alpha = 1
            }
            UIView.animateWithDuration(duration + 0.2, delay: 0,
                usingSpringWithDamping: 0.7,
                initialSpringVelocity: 0.2,
                options: .CurveEaseOut,
                animations: {
                    self.nameLabel.frame.origin.x = originalX
                }, completion: nil)
        }

        UIView.animateWithDuration(duration - 0.1, delay: 0, options: .CurveEaseIn, animations: flyOut, completion: flyIn)
    }

    // MARK: iCarouselDataSource

    func numberOfItemsInCarousel(carousel: iCarousel!) -> Int {
        return names.count
    }

    func carousel(carousel: iCarousel!, viewForItemAtIndex index: Int, reusingView view: UIView!) -> UIView! {
        var mutableView = view

        if mutableView == nil {
            mutableView = UIView(frame: CGRect(x: 0, y: 0, width: 160, height: 160))
            mutableView.backgroundColor = UIColor(white: 0.25, alpha: 1)
        } else {
            (mutableView.subviews.first as! UIView).removeFromSuperview()
        }

        let imageView = UIImageView()
        mutableView.addSubview(imageView)

        onMain {
            // Even though we're on the main queue at this point, dispatching to it will cause
            // mutableView to be returned BEFORE loading the image file, reducing FPS lag.
            let image = UIImage(named: self.names[index])
            imageView.contentMode = .ScaleAspectFill
            imageView.frame = CGRect(x: 15, y: 15, width: 130, height: 130)
            imageView.clipsToBounds = true
            imageView.image = image
        }

        return mutableView
    }

    // MARK: Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch (segue.identifier!) {
        case biosID1, biosID2, biosID3:
            let toViewController = segue.destinationViewController as! InfoViewController
            toViewController.modalPresentationStyle = .CurrentContext
            toViewController.transitioningDelegate = toViewController.transitionManager
        default:
            p("unknown segue identifier: \(segue.identifier)")
        }
    }

}
