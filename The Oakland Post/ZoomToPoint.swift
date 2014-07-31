//
//  ZoomToPoint.swift
//  The Oakland Post
//
//  Created by Andrew Clissold on 7/30/14.
//  Ported to Swift from https://gist.github.com/TimOliver/6138097
//  Tim Oliver's blog post on the matter:
//      http://www.timoliver.com.au/2012/01/14/zooming-to-a-point-in-uiscrollview/
//

extension UIScrollView {
    func zoomToPoint(point: CGPoint, withScale scale: CGFloat, animated: Bool) {
        var x, y, width, height: CGFloat

        //Normalize current content size back to content scale of 1.0f
        width = (self.contentSize.width / self.zoomScale)
        height = (self.contentSize.height / self.zoomScale)
        var contentSize = CGSize(width: width, height: height)

        //translate the zoom point to relative to the content rect
        x = (point.x / self.bounds.size.width) * contentSize.width
        y = (point.y / self.bounds.size.height) * contentSize.height
        var zoomPoint = CGPoint(x: x, y: y)

        //derive the size of the region to zoom to
        width = self.bounds.size.width / scale
        height = self.bounds.size.height / scale
        var zoomSize = CGSize(width: width, height: height)

        //offset the zoom rect so the actual zoom point is in the middle of the rectangle
        x = zoomPoint.x - zoomSize.width / 2.0
        y = zoomPoint.y - zoomSize.height / 2.0
        width = zoomSize.width
        height = zoomSize.height
        var zoomRect = CGRect(x: x, y: y, width: width, height: height)

        //apply the resize
        self.zoomToRect(zoomRect, animated: animated)
    }
}
