//
//  PostViewController.swift
//  The Oakland Post
//
//  Created by Andrew Clissold on 6/13/14.
//  Copyright (c) 2014 Andrew Clissold. All rights reserved.
//

import UIKit

class PostViewController: UIViewController {

    var url: String? {
        didSet {
            self.configureView()
        }
    }

    func configureView() {
        if let url = self.url {
            println("view configured with \(url)")
        }
    }

}
