//
//  GCD.swift
//  The Oakland Post
//
//  Helper functions for Grand Central Dispatch.
//
//  Usage:
//
//      onDefault {
//          println("hello, asynchronous world")
//      }
//
//      onMain {
//          // perform UI tasks
//      }
//
//  Created by Andrew Clissold on 7/24/14.
//  Copyright (c) 2014 Andrew Clissold. All rights reserved.
//

func onMain(block: dispatch_block_t) {
    let queue = dispatch_get_main_queue()
    dispatch_async(queue, block)
}

func onHigh(block: dispatch_block_t) {
    let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)
    dispatch_async(queue, block)
}

func onDefault(block: dispatch_block_t) {
    let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
    dispatch_async(queue, block)
}
