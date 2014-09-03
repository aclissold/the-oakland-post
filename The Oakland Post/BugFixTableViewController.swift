//
//  BugFixTableViewController.swift
//
//  Provides a fix for UITableViewCells flickering and getting stuck as selected
//  when the swipe-from-left gesture to go back is performed in a certain manner.
//
//  Subclasses overriding these methods must remember to call super for it to work properly.
//
//  Created by Andrew Clissold on 7/12/14.
//  Copyright (c) 2014 Andrew Clissold. All rights reserved.
//
//  https://github.com/aclissold/BugFixTableViewController
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  * Redistributions of source code must retain the above copyright notice, this
//    list of conditions and the following disclaimer.
//
//  * Redistributions in binary form must reproduce the above copyright notice,
//    this list of conditions and the following disclaimer in the documentation
//    and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
//  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
//  FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
//  DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
//  SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
//  CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
//  OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
//  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//

import UIKit

class BugFixTableViewController: UITableViewController {

    // private
    var lastIndexPath: NSIndexPath?

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        lastIndexPath = indexPath
    }

    override func viewWillAppear(animated: Bool)  {
        if lastIndexPath != nil {
            tableView.deselectRowAtIndexPath(lastIndexPath!, animated: true)
        }
    }

    override func viewDidAppear(animated: Bool) {
        if lastIndexPath != nil {
            lastIndexPath = nil
        }
    }

    override func viewDidDisappear(animated: Bool)  {
        if lastIndexPath != nil {
            tableView.selectRowAtIndexPath(lastIndexPath!, animated: false, scrollPosition: .None)
        }
    }

}
